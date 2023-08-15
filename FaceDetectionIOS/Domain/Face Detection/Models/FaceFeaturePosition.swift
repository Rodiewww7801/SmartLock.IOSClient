//
//  FaceFeaturePosition.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 12.08.2023.
//

import Foundation

struct FaceFeaturePosition {
    let faceBounds: CGRect
    let leftEyePosition: CGPoint
    let rightEyePosition: CGPoint
    let mouthPosition: CGPoint
    let centerPosition: CGPoint
}
