//
//  DetectionSceneViewModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import Foundation
import UIKit

protocol DetectionScenePresentedDelegate: AnyObject {
    func updateFaceGeometry()
    func updateFaceState()
    func capturePhotoObservation(image: UIImage)
    func onShowUserCard(user: UserCardModel)
    func showLoadingScreen()
    func stopLoadingScreen()
    func debugMode()
}

class DetectionSceneViewModel {
    private var userRepository: UserRepositoryProtocol
    private let lockId: String
    private let validationDispatchQueue = DispatchQueue(label: "validation_face_queue", qos: .background, autoreleaseFrequency: .workItem)
    private var validationTask: Task<Void, Never>?
    
    private(set) var faceDetector: FaceDetector
    private(set) var faceDetectedState: FaceObservation<Void>
    private(set) var faceGemetryState: FaceObservation<FaceGeometryModel>
    private(set) var lastCapturedPhoto: UIImage?
    
    private(set) var faceValidationState: Bool
    private(set) var isAcceptableRoll: Bool
    private(set) var isAcceptablePitch: Bool
    private(set) var isAcceptableYaw: Bool
    private(set) var isAcceptableQuality: Bool
    private(set) var isAcceptableBounds: FaceBoundsState
    private(set) var isAcceptableAuthenticity: Bool
    private(set) var faceWasValidated: Bool
    
    var debugModeEnabled: Bool {
        didSet {
            self.presentedDelegate?.debugMode()
        }
    }
    var hideBackgroundModeEnabled: Bool
    var faceLayoutGuideFrame: CGRect = {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGRect(x: 0, y: 0, width: ( screenSize.height * 0.4) / 1.5, height: screenSize.height * 0.4)
    }()
    
    weak var presentedDelegate: DetectionScenePresentedDelegate?
    
    init(lockId: String) {
        self.lockId = lockId
        self.userRepository = RepositoryFactory.userRepository()
        
        faceDetector = FaceDetector()
        faceDetectedState = .faceNotFound
        faceGemetryState = .faceNotFound
        
        faceValidationState = false
        isAcceptableRoll = false
        isAcceptablePitch = false
        isAcceptableYaw = false
        isAcceptableQuality = false
        isAcceptableBounds = .unknown
        isAcceptableAuthenticity = false
        faceWasValidated = false
        
        debugModeEnabled = false
        hideBackgroundModeEnabled = false
        
        print("[DetectionSceneViewModel]: init")
    }
    
    deinit {
        print("[DetectionSceneViewModel]: deinit")
    }
    
    //MARK: - public func
    
    func setPresentedDelegate(_ delegate: DetectionScenePresentedDelegate) {
        self.presentedDelegate = delegate
        self.faceDetector.viewModelDelegate = self
        setWindowSize()
    }
    
    func publishTakePhotoObservation() {
        presentedDelegate?.showLoadingScreen()
        print("[DetectionSceneViewModel]: capture current photo")
        faceDetector.captureCurrentImage()
    }
    
    func unvalidateFace() {
        self.faceWasValidated = false
    }
    
    //MARK: - private func
    
    private func setWindowSize() {
        let toRect = UIScreen.main.bounds
        faceLayoutGuideFrame = CGRect(
            x: toRect.midX - faceLayoutGuideFrame.width / 2,
            y: toRect.midY - faceLayoutGuideFrame.height / 2,
            width: faceLayoutGuideFrame.width, height: faceLayoutGuideFrame.height)
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
            self.setAcceptableAuthenticity(authenticity: faceGeometryModel.faceAuthenticity)
            
            self.tryToStartTimer()
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
        self.isAcceptableQuality = false
        self.isAcceptableBounds = .unknown
    }
    
    private func validateDetectedFace() {
        validationDispatchQueue.sync { [weak self] in
            guard let self = self else { return }
            self.faceValidationState = isAcceptableRoll &&
            isAcceptablePitch &&
            isAcceptableYaw &&
            isAcceptableBounds == .detectedFaceAppropriateSizeAndPosition &&
            isAcceptableQuality &&
            isAcceptableAuthenticity
        }
    }
    
    private func setAcceptableRollPitchYaw(using roll: Double, pitch: Double, yaw: Double) {
        self.isAcceptableRoll = (roll > 1.4 && roll < 1.7)
        self.isAcceptablePitch = abs(CGFloat(pitch)) < 0.2
        self.isAcceptableYaw = abs(CGFloat(yaw)) < 0.15
    }
    
    private func setAcceptableBounds(using boundingBox: CGRect) {
        if boundingBox.width > 1.2 * faceLayoutGuideFrame.width {
            isAcceptableBounds = .detectedFaceTooLarge
        } else if boundingBox.width * 1.2 < faceLayoutGuideFrame.width {
            isAcceptableBounds = .detectedFaceTooSmall
        } else {
            if abs(boundingBox.midX - faceLayoutGuideFrame.midX) > 50 {
                isAcceptableBounds = .detectedFaceOffCentre
            } else if abs(boundingBox.midY - faceLayoutGuideFrame.midY) > 50 {
                isAcceptableBounds = .detectedFaceOffCentre
            } else {
                isAcceptableBounds = .detectedFaceAppropriateSizeAndPosition
            }
        }
    }
    
    private func setAcceptableFaceQuality(using quality: Float) {
        if quality < 0.2 {
            self.isAcceptableQuality = false
        } else {
            self.isAcceptableQuality = true
        }
    }
    
    private func setAcceptableAuthenticity(authenticity: FaceAuthenticity) {
        switch authenticity {
        case .realFace:
            self.isAcceptableAuthenticity = true
        default:
            self.isAcceptableAuthenticity = false
        }
    }
    
    private func stateOfDetectionWasChanged() {
        processFaceGeometryState()
        validateDetectedFace()
        self.presentedDelegate?.updateFaceGeometry()
        self.presentedDelegate?.updateFaceState()
    }
    
    private func getUser(images: [UIImage], _ completion: @escaping (UserCardModel?)->Void) {
        Task { [weak self] in
            guard let lockId = self?.lockId else { return }
            let user = await self?.userRepository.getUserCardModel(lockId: lockId, images: images)
            completion(user)
        }
    }
    
    private func tryToStartTimer() {
        validationDispatchQueue.sync { [weak self] in
            guard let self = self else { return }
            
            if self.faceValidationState, !self.faceWasValidated, self.validationTask == nil {
                print("[DetectionSceneViewModel]: validation task was started")
                self.validationTask = Task.detached(priority: .background, operation: {
                    try? await Task.sleep(for: .seconds(3))
                    if self.validationTask?.isCancelled == false, self.faceValidationState {
                        self.faceWasValidated = true
                        self.publishTakePhotoObservation()
                    }
                })
            } else if !self.faceValidationState, self.validationTask != nil {
                print("[DetectionSceneViewModel]: validation task was canceled")
                self.validationTask?.cancel()
                self.validationTask = nil
            }
        }
    }
}

//MARK: - FaceDectorDelegateViewModel

extension DetectionSceneViewModel: FaceDetectorDelegate {
    func publishNoFaceObserved() {
        faceGemetryState = .faceNotFound
        stateOfDetectionWasChanged()
    }
    
    func publishFaceObservation(_ faceGeometryModel: FaceGeometryModel) {
        faceGemetryState = .faceFound(faceGeometryModel)
        stateOfDetectionWasChanged()
    }
    
    func publishSavePhotoObservation(_ image: UIImage) {
        self.getUser(images: [image]) { [weak self] user in
            self?.presentedDelegate?.stopLoadingScreen()
            if let user = user {
                self?.presentedDelegate?.onShowUserCard(user: user)
            } else {
                self?.unvalidateFace()
            }
        }
    }
    
    func getHideBackgroundState() -> Bool {
        return self.hideBackgroundModeEnabled
    }
}
