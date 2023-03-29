//
//  MainCameraViewModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import Foundation
import UIKit

class MainCameraViewModel {
    var debugModeEnabled: Bool
    var hideBackgroundModeEnabled: Bool
    var faceLayourGuidFrame: 
    
    private(set) var faceDetectedState: FaceDetectedState
    private(set) var faceGemetryState: FaceObservation<FaceGeometryModel>
    private(set) var faceQualityState: FaceObservation<FaceQualityModel>
    private(set) var lastCapturedPhoto: UIImage?
    
    
}
