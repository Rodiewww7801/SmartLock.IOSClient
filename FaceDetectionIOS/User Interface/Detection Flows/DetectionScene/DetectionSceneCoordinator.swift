//
//  DetectionSceneCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 09.06.2023.
//

import UIKit
import AVFoundation

class DetectionSceneCoordinator: Coordinator {
    
    let router: Router
    var alert: FDAlert?
    var removeCoordinator: (()->())?
    
    private var detectionSceneViewModel: DetectionSceneViewModel?
    private var detectionSceneVC: DetectionSceneVC?
    
    init(router: Router) {
        self.router = router
        print("[DetectionSceneCoordinator]: init")
    }
    
    deinit {
        print("[DetectionSceneCoordinator]: deinit")
    }
    
    override func start() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showDetectionScene()
        default:
            showAlert()
        }
    }
    
    private func showDetectionScene() {
        let detectionSceneViewModel = DetectionSceneViewModel()
        let detectionScene = DetectionSceneVC(with: detectionSceneViewModel)
        detectionScene.showSettings = { [weak self] in
            self?.showDetecetionSceneSettingsViewController()
        }
        detectionScene.onBackTapped = { [weak self] in
            self?.removeCoordinator?()
        }
        self.detectionSceneVC = detectionScene
        self.detectionSceneViewModel = detectionSceneViewModel
        router.push(detectionScene, animated: true)
    }
    
    private func showAlert() {
        self.alert = FDAlert()
            .createWith(title: "Error", message: "FaceDetection app doesn't have permission to use the camera, please change privacy settings")
            .addAction(title: "Settings", style: .default, handler: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                          options: [:],
                                          completionHandler: nil)
            })
            .addAction(title: "Close", style: .destructive, handler: {
                self.start()
            })
            .present(on: router)
    }
    
    private func showDetecetionSceneSettingsViewController() {
        guard let detectionSceneViewModel = detectionSceneViewModel else { return }
        let detecetionSceneSettingsViewController = DetecetionSceneSettingsViewController(with: detectionSceneViewModel)
        detecetionSceneSettingsViewController.delegate = self.detectionSceneVC
        router.push(detecetionSceneSettingsViewController, animated: true)
    }
}
