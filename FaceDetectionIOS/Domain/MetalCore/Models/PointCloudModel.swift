//
//  PointCloudModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 16.06.2023.
//

import Foundation
import MetalKit
import AVFoundation

class PointCloudModel: Transformable {
    private var capturedImageTextureCache: CVMetalTextureCache?
    private var depthTextureCache: CVMetalTextureCache?
    private var modelType: ModelType = ModelType()
    
    var transform: Transform
    var depthData: AVDepthData?
    var capturedImage: CVPixelBuffer?
    
    init(device: MTLDevice) {
        self.transform = Transform()
        self.transform.rotation = [0,0, Float(-90).degreesToRadians]
        
        self.modelType.pointToCloud = 1
        
        CVMetalTextureCacheCreate(nil, nil, device, nil, &self.capturedImageTextureCache)
        CVMetalTextureCacheCreate(nil, nil, device, nil, &self.depthTextureCache)
    }
}

extension PointCloudModel: RenderModel {
    func render(encoder: MTLRenderCommandEncoder, uniform: Uniform) {
        guard let depthData = self.depthData,
              let pixelBuffer = self.capturedImage
        else {
            print("[PointCloudModel]: AVDepthData or CVPixelBuffer does not init")
            return
        }
        
        // create textures
        let depthPixelBuffer: CVPixelBuffer = depthData.depthDataMap
        var depthTexture: MTLTexture?
        if let depthTextureCache = self.depthTextureCache {
            depthTexture = depthPixelBuffer.texture(withFormat: .r32Float, addToCache: depthTextureCache)
        } else {
            print("[PointCloudModel]: depthTexture failed to init")
        }
        
        var colorTextureY: MTLTexture?
        var colorTextureCbCr: MTLTexture?
        if let capturedImageTextureCache = self.capturedImageTextureCache {
            colorTextureY = pixelBuffer.texture(withFormat: .r8Unorm, planeIndex: 0, addToCache: capturedImageTextureCache)
            colorTextureCbCr = pixelBuffer.texture(withFormat: .rg8Unorm, planeIndex: 1, addToCache: capturedImageTextureCache)
        } else {
            print("[PointCloudModel]: colorTexture failed to init")
        }
        
        // calculate camera calibration
        var cameraCalibrationData: CameraCalibrationData? 
        if var cameraIntrinsics = depthData.cameraCalibrationData?.intrinsicMatrix,
           let referenceDemension = depthData.cameraCalibrationData?.intrinsicMatrixReferenceDimensions {
            let ratio = Float(referenceDemension.width) / Float(CVPixelBufferGetWidth(depthPixelBuffer))
            cameraIntrinsics[0][0] /= ratio
            cameraIntrinsics[1][1] /= ratio
            cameraIntrinsics[2][0] /= ratio
            cameraIntrinsics[2][1] /= ratio
            cameraCalibrationData = CameraCalibrationData(cameraIntrinsics: cameraIntrinsics)
        }
        
        var uniform = uniform
        uniform.modelMatrix = self.transform.transformMatrix
        encoder.setVertexBytes(&uniform,
                               length: MemoryLayout<Uniform>.stride,
                               index: kBufferIndexUniform.index)
        encoder.setVertexBytes(&modelType,
                               length: MemoryLayout<ModelType>.stride,
                               index: kBufferIndexModelType.index)
        encoder.setFragmentBytes(&modelType,
                                 length: MemoryLayout<ModelType>.stride,
                                 index: kBufferIndexModelType.index)
        encoder.setVertexBytes(&cameraCalibrationData,
                               length: MemoryLayout<CameraCalibrationData>.stride,
                               index: kBufferIndexCameraCalibrationData.index)
        encoder.setVertexTexture(depthTexture,
                                 index: kTextureIndexDepth.index)
        encoder.setFragmentTexture(colorTextureY,
                                   index: kTextureIndexY.index)
        encoder.setFragmentTexture(colorTextureCbCr,
                                   index: kTextureIndexCbCr.index)
        encoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: CVPixelBufferGetWidth(depthPixelBuffer) * CVPixelBufferGetHeight(depthPixelBuffer))
    }
}
