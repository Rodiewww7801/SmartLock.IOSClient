//
//  DetectionCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation
import AVFoundation
import UIKit

final class DetectionCoordinator: Coordinator {
    let router: Router
    var alert: FDAlert?
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //showDetectionScene()
            showTrueDepthScene()
         default:
            showAlert()
        }
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
    
    private func showDetectionScene() {
        let viewModel = DetectionSceneViewModel()
        let vc = DetectionSceneVC(with: viewModel)
        router.setToRootModule(vc, animated: true)
    }
    
    private func showTrueDepthScene() {
        let vc = DepthDataViewController()
        router.setToRootModule(vc, animated: true)
    }
}
