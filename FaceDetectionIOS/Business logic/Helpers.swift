//
//  Helpers.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 29.03.2023.
//

import Foundation
import UIKit

//todo segregate

enum CameraViewModelAction {
    case noFaceDetected
    case faceObservationDetected(FaceGeometryModel)
    case toggleDebugMode
    case toggleHideBackground
    case takePhoto
    case savePhoto(UIImage)
}

enum FaceDetectedState {
    case faceDetected
    case noFaceDetected
    case faceDetectionErrored
}

enum FaceBoundsState {
    case unknown
    case detectedFaceTooSmall
    case detectedFaceTooLarge
    case detectedFaceOffCentre
    case detectedFaceAppropriateSizeAndPosition
}

enum FaceObservation<T> {
    case faceFound(T)
    case faceNotFound
    case errored(Error)
}

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
