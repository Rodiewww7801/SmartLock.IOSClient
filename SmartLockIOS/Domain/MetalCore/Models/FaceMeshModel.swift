//
//  FaceMeshModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.06.2023.
//

import Foundation
import MetalKit

class FaceMeshModel: Transformable {
    private var baseTransform: float4x4 = .identity
    private var vertices: [vector_float3] = []
    private var facePointsBufferAddress: UnsafeMutableRawPointer!
    private var facePointsBuffer: MTLBuffer!
    
    var transform: Transform = Transform()
    var modelType: ModelType = ModelType()

    init(device: MTLDevice) {
        facePointsBuffer = device.makeBuffer(length: (MemoryLayout<vector_float3>.stride * 1220), options: [])
        facePointsBuffer.label = "FacePointBuffer"
        self.transform.scale = 10000
        modelType.faceMesh = 1
    }
    
    var modelMatrix: float4x4 {
        return baseTransform
    }
    
    func setFaceMeshData(vertices: [vector_float3], transform: float4x4) {
        self.vertices = vertices
        self.baseTransform = transform
        
        
        facePointsBufferAddress = facePointsBuffer.contents()
        for index in 0..<vertices.count {
            let curPointAddr = facePointsBufferAddress.assumingMemoryBound(to: vector_float3.self).advanced(by: index)
            curPointAddr.pointee = vertices[index]
        }
    }
}

extension FaceMeshModel: RenderModel {
    func render(encoder: MTLRenderCommandEncoder, uniform: Uniform) {
        guard !vertices.isEmpty else { return }
        encoder.setVertexBytes(&vertices, length: MemoryLayout<vector_float3>.stride * 1220, index: kBufferIndexFaceMeshVertices.index)
        var uniform = uniform
        uniform.modelMatrix = baseTransform
        //encoder.setVertexBuffer(facePointsBuffer, offset: 0, index: kBufferIndexFaceMeshVertices.index)
        encoder.setVertexBytes(&uniform, length: MemoryLayout<Uniform>.stride, index: kBufferIndexUniform.index)
        encoder.setVertexBytes(&modelType, length: MemoryLayout<ModelType>.stride, index: kBufferIndexModelType.index)
        encoder.setFragmentBytes(&modelType, length: MemoryLayout<ModelType>.stride, index: kBufferIndexModelType.index)
        encoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: 1220)
    }
}
