//
//  CameraViewModelAction.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 30.03.2023.
//

import UIKit

enum CameraViewModelAction {
    case noFaceDetected
    case faceObservationDetected(FaceGeometryModel)
    case toggleHideBackground
    case takePhoto
    case savePhoto(UIImage)
}
