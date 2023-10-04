//
//  Transform.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 25.05.2023.
//

import Foundation

protocol Transformable {
    var transform: Transform {get set}
}

struct Transform {
    var position: float3 = [0,0,0]
    var rotation: float3 = [0,0,0]
    var scale: Float = 1
    
    var transformMatrix: float4x4 {
        let positionMatrix = float4x4(translation: self.position)
        let rotationMatrix = float4x4(rotation: self.rotation)
        let scaleMatrix = float4x4(scaling: self.scale)
        let modelMatrix = positionMatrix * rotationMatrix * scaleMatrix
       return modelMatrix
    }
}
