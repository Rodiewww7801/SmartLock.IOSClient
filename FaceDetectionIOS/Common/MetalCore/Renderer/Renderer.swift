//
//  Renderer.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 21.05.2023.
//

import Foundation
import MetalKit
import AVFoundation

class Renderer: NSObject {
    // Static
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var library: MTLLibrary!
    
    // MetalKit
    private var metalView: MTKView
    private var renderPipelineState: MTLRenderPipelineState!
    private var depthStencilState: MTLDepthStencilState!
    
    // AVFoundation
    private var depthData: AVDepthData?
    
    // Core video
    private var pixelBuffer: CVPixelBuffer?
    private var depthTextureCache: CVMetalTextureCache?
    private var colorTextureCache: CVMetalTextureCache?
    
    //helper variable
    private var timer: Float = 0
    var camera: ArcballCamera?
    
    init(mtkView: MTKView) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else {
            fatalError("[Renderer]: failed init")
        }
        self.device = device
        self.metalView = mtkView
        self.commandQueue = commandQueue
        super.init()
        
        self.metalView.delegate = self
        self.metalView.device = self.device
        
        setup()
        setupCamera()
    }
    
    private func setup() {
        CVMetalTextureCacheCreate(nil, nil, self.device, nil, &self.depthTextureCache)
        CVMetalTextureCacheCreate(nil, nil, self.device, nil, &self.colorTextureCache)
        metalView.colorPixelFormat = .bgra8Unorm
        
        createLibrary()
        let renderPipelineState = createRenderPipelineState()
        let depthStencilState = createDepthStencilState()
        self.renderPipelineState = renderPipelineState
        self.depthStencilState = depthStencilState
    }
    
    private func createLibrary() {
        self.library = self.device.makeDefaultLibrary()
    }
    
    private func createRenderPipelineState() -> MTLRenderPipelineState {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexShaderPoints")
        renderPipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentShaderPoints")
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = self.metalView.colorPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            let renderPipelineState = try self.device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
            return renderPipelineState
        } catch {
            fatalError("[Renderer] \(error)")
        }
    }
    
    private func createDepthStencilState() -> MTLDepthStencilState? {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        
        let depthStencilState = self.device.makeDepthStencilState(descriptor: depthStencilDescriptor)
        
        return depthStencilState
    }
    
    func setDepthFrame(depth: AVDepthData, withTexture unormTexture: CVPixelBuffer) {
        self.depthData = depth
        self.pixelBuffer = unormTexture
    }
    
    func setupCamera() {
        self.camera = ArcballCamera()
        guard let camera = self.camera else { return }
        camera.transform.rotation = [0,0,0]
        camera.transform.position = [0,0,-350]
        camera.distance = length(camera.transform.position)
        camera.target = [0,0,350]
    }
}

// MARK: - MTKViewDelegate

extension Renderer: MTKViewDelegate {
    
    private func getViewMatrix() -> float4x4 {
        guard let camera = self.camera else { return .identity }

        
        camera.update(size: metalView.drawableSize)
        camera.update()
        
        return camera.projectionMatrix * camera.viewMatrix * float4x4(rotation: [0,0,Float(-90).degreesToRadians])
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //
    }
    
    func draw(in view: MTKView) {
        timer += 0.01
        renderPointToCloud(in: view)
    }
    
    private func renderPointToCloud(in view: MTKView) {
        guard let depthData = self.depthData,
              let pixelBuffer = self.pixelBuffer,
              let depthTextureCache = self.depthTextureCache,
              let colorTextureCache = self.colorTextureCache
        else {
            return
        }
        
        //create texture from depth data
        let depthPixelBuffer: CVPixelBuffer = depthData.depthDataMap
        var cvDepthTexture: CVMetalTexture?
        let depthTextureFromImage = CVMetalTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault,
            depthTextureCache,
            depthPixelBuffer,
            nil,
            .r16Float,
            CVPixelBufferGetWidth(depthPixelBuffer),
            CVPixelBufferGetHeight(depthPixelBuffer),
            0,
            &cvDepthTexture)
        
        guard kCVReturnSuccess == depthTextureFromImage,
              let cvDepthTexture = cvDepthTexture,
              let depthTexture: MTLTexture = CVMetalTextureGetTexture(cvDepthTexture)
        else {
            print("[Renderer]: Failed to create depth texture")
            return
        }
        
        //create texture from color from pixel buffer
        var cvColorTexture: CVMetalTexture?
        let colorTextureFromImage = CVMetalTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault,
            colorTextureCache,
            pixelBuffer,
            nil,
            .bgra8Unorm,
            CVPixelBufferGetWidth(pixelBuffer),
            CVPixelBufferGetHeight(pixelBuffer),
            0,
            &cvColorTexture)
        
        guard kCVReturnSuccess == colorTextureFromImage,
              let cvColorTexture = cvColorTexture,
              let colorTexture: MTLTexture = CVMetalTextureGetTexture(cvColorTexture)
        else {
            print("[Renderer]: Failed to create color texture")
            return
        }
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDiscriptor = self.metalView.currentRenderPassDescriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDiscriptor)
        else {
            print("[Renderer]: Failed to create render command encoder")
            return
        }
        
        var intrinsics = depthData.cameraCalibrationData?.intrinsicMatrix
        let referenceDimensions = depthData.cameraCalibrationData?.intrinsicMatrixReferenceDimensions ?? .zero
        let ratio = Float(referenceDimensions.width) / Float(CVPixelBufferGetWidth(depthPixelBuffer))
        intrinsics?[0][0] /= ratio
        intrinsics?[1][1] /= ratio
        intrinsics?[2][0] /= ratio
        intrinsics?[2][1] /= ratio
        
        
//        let depthTextureDescriptor = MTLTextureDescriptor()
//        depthTextureDescriptor.width = Int(view.drawableSize.width)
//        depthTextureDescriptor.height = Int(view.drawableSize.height)
//        depthTextureDescriptor.pixelFormat = .depth32Float
//        depthTextureDescriptor.usage = .renderTarget
        
//        let depthTestTexture = device.makeTexture(descriptor: depthTextureDescriptor)
//        renderPassDiscriptor.depthAttachment.loadAction = .clear
//        renderPassDiscriptor.depthAttachment.storeAction = .store
//        renderPassDiscriptor.depthAttachment.clearDepth = 1.0
//        renderPassDiscriptor.depthAttachment.texture = depthTestTexture
        
        renderEncoder.setDepthStencilState(self.depthStencilState)
        renderEncoder.setRenderPipelineState(self.renderPipelineState)
        renderEncoder.setVertexTexture(depthTexture, index: 0)
        var viewMatrix = getViewMatrix()
        renderEncoder.setVertexBytes(&viewMatrix, length: MemoryLayout<float4x4>.stride, index: 0)
        renderEncoder.setVertexBytes(&intrinsics, length: MemoryLayout<matrix_float3x3>.stride, index: 1)
        
        
        renderEncoder.setFragmentTexture(colorTexture, index: 0)
        renderEncoder.drawPrimitives(type: .point, vertexStart: 0,
                                     vertexCount: CVPixelBufferGetWidth(depthPixelBuffer) * CVPixelBufferGetHeight(depthPixelBuffer))
        renderEncoder.endEncoding()
        
        guard let currentDrawable = view.currentDrawable else {
            print("[Renderer]: Coudn't render view")
            return
        }
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
