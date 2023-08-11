//
//  Renderer.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 21.05.2023.
//

import Foundation
import MetalKit
import AVFoundation
import ARKit

class Renderer: NSObject {
    // Static
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private var library: MTLLibrary!
    
    // MetalKit
    private var metalView: MTKView
    private var renderPipelineState: MTLRenderPipelineState!
    private var depthStencilState: MTLDepthStencilState!
    
    //helper variable
    private var timer: Float = 0
    private var faceMeshModel: FaceMeshModel?
    private var pointCloudModel: PointCloudModel?
    private var uniform: Uniform = Uniform()
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
    }
    
    private func setup() {
        metalView.colorPixelFormat = .bgra8Unorm
        
        createLibrary()
        let renderPipelineState = createRenderPipelineState()
        let depthStencilState = createDepthStencilState()
        self.renderPipelineState = renderPipelineState
        self.depthStencilState = depthStencilState
        
        setupCamera()
        setupModels()
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
    
    private func setupCamera() {
        self.camera = ArcballCamera()
        guard let camera = self.camera else { return }
        camera.distance = 350
        camera.target = [0,0,350]
    }
    
    private func setupModels() {
        self.pointCloudModel = PointCloudModel(device: self.device)
        self.faceMeshModel = FaceMeshModel(device: self.device)
    }
    
    // MARK: - public methods
    
    func setDepthFrame(depth: AVDepthData, withTexture unormTexture: CVPixelBuffer) {
        pointCloudModel?.depthData = depth
        pointCloudModel?.capturedImage = unormTexture
    }
    
    func setFaceMeshModel(_ vertices: [vector_float3], _ transform: float4x4) {
        self.faceMeshModel = FaceMeshModel(device: self.device)
        self.faceMeshModel?.setFaceMeshData(vertices: vertices, transform: transform)
    }
}

// MARK: - MTKViewDelegate

extension Renderer: MTKViewDelegate {
    
    private func updateCamera() {
        guard let camera = self.camera else { return }
        camera.update(size: metalView.drawableSize)
        camera.update()
        
        self.uniform.projectionMatrix = camera.projectionMatrix
        self.uniform.viewMatrix = camera.viewMatrix
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateCamera()
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor
        else {
            return
        }
        
        timer += 0.01
        
        let depthTextureDescriptor = MTLTextureDescriptor()
        depthTextureDescriptor.width = Int(view.drawableSize.width)
        depthTextureDescriptor.height = Int(view.drawableSize.height)
        depthTextureDescriptor.pixelFormat = .depth32Float
        depthTextureDescriptor.usage = .renderTarget

        let depthTestTexture = device.makeTexture(descriptor: depthTextureDescriptor)
        renderPassDescriptor.depthAttachment.loadAction = .clear
        renderPassDescriptor.depthAttachment.storeAction = .store
        renderPassDescriptor.depthAttachment.clearDepth = 1.0
        renderPassDescriptor.depthAttachment.texture = depthTestTexture

        guard let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }

        encoder.setDepthStencilState(self.depthStencilState)
        encoder.setRenderPipelineState(self.renderPipelineState)

        updateCamera()
        pointCloudModel?.render(encoder: encoder, uniform: self.uniform)
        faceMeshModel?.render(encoder: encoder, uniform: self.uniform)

        encoder.endEncoding()
        guard let currentDrawable = view.currentDrawable else { return }
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}
