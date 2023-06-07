//
//  FaceGeometryModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 30.03.2023.
//

import Foundation

struct FaceGeometryModel {
    let boundingBox: CGRect
    let roll: NSNumber
    let pitch: NSNumber
    let yaw: NSNumber
    let quality: Float
    
    init(boundingBox: CGRect, roll: NSNumber?, pitch: NSNumber?, yaw: NSNumber?, quality: Float = 0) {
        self.boundingBox = boundingBox
        self.roll = roll ?? 0
        self.pitch = pitch ?? 0
        self.yaw = yaw ?? 0
        self.quality = quality
    }
}

enum FaceObservation<T> {
    case faceFound(T)
    case faceNotFound
    case errored(Error)
}
