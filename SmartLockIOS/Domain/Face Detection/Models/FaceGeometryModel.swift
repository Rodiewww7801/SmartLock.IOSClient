//
//  FaceGeometryModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 30.03.2023.
//

import Foundation

struct FaceGeometryModel {
    var boundingBox: CGRect
    var roll: NSNumber
    var pitch: NSNumber
    var yaw: NSNumber
    var quality: Float
    var faceContourPoints: [CGPoint]
    var faceAuthenticity: FaceAuthenticity
    
    init() {
        self.boundingBox = .zero
        self.roll = 0
        self.pitch = 0
        self.yaw = 0
        self.quality = 0
        self.faceContourPoints = []
        self.faceAuthenticity = .fakeFace
    }
}
