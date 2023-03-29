//
//  MainCameraViewModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import Foundation
import UIKit

protocol MainCameraViewModelDelegate: AnyObject {
    func updateFaceGeometry()
    func updateFaceState()
}

class MainCameraViewModel {
    private(set) var faceDetectedState: FaceDetectedState
    private(set) var faceGemetryState: FaceObservation<FaceGeometryModel>
    private(set) var lastCapturedPhoto: UIImage?
    
    private(set) var hasDetectedValidFace: Bool
    private(set) var isAcceptableRoll: Bool
    private(set) var isAcceptablePitch: Bool
    private(set) var isAcceptableYaw: Bool
    private(set) var isAcceptableQuality: Bool
    private(set) var isAcceptableBounds: FaceBoundsState
    
    var debugModeEnabled: Bool
    var hideBackgroundModeEnabled: Bool
    private var faceLayoutGuideFrame: CGRect = {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGRect(x: 0, y: 0, width: ( screenSize.height * 0.4) / 1.5, height: screenSize.height * 0.4)
    }()
    
    weak var presentedDelegate: MainCameraViewModelDelegate?
    
    convenience init(with presentedDelegate: MainCameraViewModelDelegate) {
        self.init()
        self.presentedDelegate = presentedDelegate
        handleWindowSizeChanged()
    }
    
    private init() {
        faceDetectedState = .noFaceDetected
        faceGemetryState = .faceNotFound
        
        hasDetectedValidFace = false
        isAcceptableRoll = false
        isAcceptablePitch = false
        isAcceptableYaw = false
        isAcceptableQuality = false
        isAcceptableBounds = .unknown
        
        debugModeEnabled = false
        hideBackgroundModeEnabled = false
    }
    
    func setDelegate(_ delegate: MainCameraViewModelDelegate) {
        self.presentedDelegate = delegate
    }
    
    private func handleWindowSizeChanged() {
        print("[MainCameraViewModel] handleWindowSizeChanged")
        let toRect = UIScreen.main.bounds
        faceLayoutGuideFrame = CGRect(
            x: toRect.midX - faceLayoutGuideFrame.width / 2,
            y: toRect.midY - faceLayoutGuideFrame.height / 2,
            width: faceLayoutGuideFrame.width, height: faceLayoutGuideFrame.height)
    }
    
    private func publishNoFaceObserved() {
        print("[MainCameraViewModel] publishNoFaceObserved")
        
        faceDetectedState = .noFaceDetected
        faceGemetryState = .faceNotFound
    }
    
    private func publishFaceObservation(_ faceGeometryModel: FaceGeometryModel) {
        print("[MainCameraViewModel] publishFaceObservation")
        
        faceDetectedState = .faceDetected
        faceGemetryState = .faceFound(faceGeometryModel)
    }
    
    private func publishDebugModeObservation() {
        print("[MainCameraViewModel] publishDebugModeObservation")
        
        debugModeEnabled.toggle()
    }
    
    private func publishTakePhotoObservation() {
        print("[MainCameraViewModel] publishTakePhotoObservation")
    }
    
    private func publishSavePhotoObservation(_ image: UIImage) {
        print("[MainCameraViewModel] publishSavePhotoObservation")
    }
    
    private func processFaceGeometryState() {
        switch self.faceGemetryState {
        case .faceFound(let faceGeometryModel):
            let roll = faceGeometryModel.roll.doubleValue
            let pitch = faceGeometryModel.pitch.doubleValue
            let yaw = faceGeometryModel.yaw.doubleValue
            let boundingBox = faceGeometryModel.boundingBox
            
            self.setAcceptableRollPitchYaw(using: roll, pitch: pitch, yaw: yaw)
            self.setAcceptableBounds(using: boundingBox)
            self.setAcceptableFaceQuality(using: faceGeometryModel.quality)
        case .faceNotFound:
            invalidateFaceGeometryState()
        case .errored(_):
            invalidateFaceGeometryState()
        }
    }
    
    private func invalidateFaceGeometryState() {
        self.isAcceptableRoll = false
        self.isAcceptablePitch = false
        self.isAcceptableYaw = false
        self.isAcceptableBounds = .unknown
    }
    
    private func validateDetectedFace() {
        self.hasDetectedValidFace = isAcceptableRoll &&
        isAcceptablePitch &&
        isAcceptableYaw &&
        isAcceptableBounds == .detectedFaceAppropriateSizeAndPosition &&
        isAcceptableQuality
    }
    
    func setAcceptableRollPitchYaw(using roll: Double, pitch: Double, yaw: Double) {
        self.isAcceptableRoll = (roll > 1.2 && roll < 1.6)
        self.isAcceptablePitch = abs(CGFloat(pitch)) < 0.2
        self.isAcceptableYaw = abs(CGFloat(yaw)) < 0.15
    }
    
    private func setAcceptableBounds(using boundingBox: CGRect) {
        if boundingBox.width > 1.2 * faceLayoutGuideFrame.width {
            isAcceptableBounds = .detectedFaceTooLarge
        } else if boundingBox.width * 1.2 < faceLayoutGuideFrame.width {
            isAcceptableBounds = .detectedFaceTooSmall
        } else {
            if abs(boundingBox.midX - faceLayoutGuideFrame.midX) > 100 {
                isAcceptableBounds = .detectedFaceOffCentre
            } else if abs(boundingBox.midY - faceLayoutGuideFrame.midY) > 100 {
                isAcceptableBounds = .detectedFaceOffCentre
            } else {
                isAcceptableBounds = .detectedFaceAppropriateSizeAndPosition
            }
        }
    }
    
    func setAcceptableFaceQuality(using quality: Float) {
        if quality < 0.2 {
            self.isAcceptableQuality = false
        }
        self.isAcceptableQuality = true
    }
}

extension MainCameraViewModel: FaceDectorDelegateViewModel {
    func perform(action: CameraViewModelAction) {
        switch action {
        case .noFaceDetected:
            publishNoFaceObserved()
        case .faceObservationDetected(let faceGeometryModel):
            publishFaceObservation(faceGeometryModel)
        case .toggleDebugMode:
            publishDebugModeObservation()
        case .toggleHideBackground:
            publishDebugModeObservation()
        case .takePhoto:
            publishTakePhotoObservation()
        case .savePhoto(let image):
            publishSavePhotoObservation(image)
        }
        
        processFaceGeometryState()
        validateDetectedFace()
        self.presentedDelegate?.updateFaceGeometry()
        self.presentedDelegate?.updateFaceState()
    }
    
    func getHideBackgroundState() -> Bool {
        return self.hideBackgroundModeEnabled
    }
}
