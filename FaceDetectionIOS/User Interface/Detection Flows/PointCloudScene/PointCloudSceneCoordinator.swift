//
//  PointCloudSceneCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 09.06.2023.
//

import Foundation
import AVFoundation
import UIKit

class PointCloudSceneCoordinator: Coordinator {
    
    let router: Router
    var alert: FDAlert?
    var removeCoordinator: (()->())?
    
    init(router: Router) {
        self.router = router
        print("[DepthDataSceneCoordinator]: init")
    }
    
    deinit {
        print("[DepthDataSceneCoordinator]: deinit")
    }
    
    override func start() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showDepthData()
        default:
            showAlert()
        }
    }
    
    private func showDepthData() {
        let depthDataViewController = PointCloudViewController()
        depthDataViewController.onBackTapped = { [weak self] in
            self?.removeCoordinator?()
        }
        depthDataViewController.showSettings = { [weak self] in
            self?.showDepthDataSettings()
        }
        router.push(depthDataViewController, animated: true)
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
    
    private func showDepthDataSettings() {
        let depthDataSettings = PointCloudSceneSettingsViewController()
        router.push(depthDataSettings, animated: true)
    }
}
