//
//  AcrballCamera.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 25.05.2023.
//

import Foundation
import UIKit

protocol Camera: Transformable, GestureController {
    var projectionMatrix: float4x4 {get}
    var viewMatrix: float4x4 {get}
    
    func update(size: CGSize)
    func update()
}

class ArcballCamera: Camera {
    private var aspect: Float
    private var fov: Float
    private var near: Float
    private var far: Float
    
    var transform: Transform
    var target: float3
    var distance: Float
    var lastScale: Float
    var rotationDelta: CGPoint
    
    var projectionMatrix: float4x4 {
       return getProjectionMatrix()
    }
    
    var viewMatrix: float4x4 {
       return getViewMatrix()
    }
    
    init() {
        self.transform = Transform()
        self.aspect = 1.0
        self.fov = Float(70).degreesToRadians
        self.near = 0.01
        self.far = 30000
        
        self.target = [0,0,0]
        self.distance = 0
        self.lastScale = 1.0
        self.rotationDelta = .zero
    }
    
    private func getProjectionMatrix() -> float4x4 {
        let projectionMatrix = float4x4(projectionFov: fov,
                                        near: near,
                                        far: far,
                                        aspect: aspect)
        return projectionMatrix
    }
    
    private func getViewMatrix() -> float4x4 {
        let viewMatrix: float4x4
        if transform.position == target {
            viewMatrix = (float4x4(translation: transform.position) * float4x4(rotationYXZ: transform.rotation)).inverse
            //viewMatrix = float4x4(eye: transform.position, center: target, up: [0,1,0])
        } else {
            viewMatrix = float4x4(eye: transform.position, center: target, up: [0,1,0])
        }
        
        return viewMatrix
    }
    
    func update(size: CGSize) {
        self.aspect = Float(size.width / size.height)
    }
    
    func update() {
        let rotateMatrix = float4x4(rotationYXZ: [transform.rotation.x, transform.rotation.y, 0])
        let distanceVector = float4(0,0,-distance,0)
        let rotatedVector = rotateMatrix * distanceVector
        self.transform.position = target + rotatedVector.xyz
    }
    
    func pinchGestureHandler(gesture: UIPinchGestureRecognizer) {
        guard gesture.numberOfTouches == 2 else { return }
        
        if gesture.state == .began {
            lastScale = 1
        }
        
        if gesture.state == .changed {
            let presentScale = Float(gesture.scale)
            let diff = lastScale -  presentScale
            if presentScale > lastScale || presentScale < lastScale { // 0 exception
                distance += diff * 1000
            }
            lastScale = presentScale
        }
    }
    
    func panGestureHandler(gesture: UIPanGestureRecognizer) {
        guard gesture.numberOfTouches == 1 else { return }
        
        if gesture.state == .began || gesture.state == .ended {
            let pnt = gesture.translation(in: gesture.view)
            rotationDelta = pnt
        } else if gesture.state != .cancelled, gesture.state != .failed {
            let pnt = gesture.translation(in: gesture.view)
            rotationDelta.x = pnt.x - rotationDelta.x
            rotationDelta.y = pnt.y - rotationDelta.y
            transform.rotation.x += Float(rotationDelta.y) * 0.01
            transform.rotation.y += Float(rotationDelta.x) * 0.01
            transform.rotation.x = max(-.pi / 2, min(transform.rotation.x, .pi / 2))
            rotationDelta = pnt
        }
    }
}
