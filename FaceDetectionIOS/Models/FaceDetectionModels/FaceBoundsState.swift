//
//  FaceBoundsState.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 30.03.2023.
//

import Foundation

enum FaceBoundsState {
    case unknown
    case detectedFaceTooSmall
    case detectedFaceTooLarge
    case detectedFaceOffCentre
    case detectedFaceAppropriateSizeAndPosition
}
