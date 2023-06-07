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
        self.showNavigationTest()
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
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            let viewModel = DetectionSceneViewModel()
            let vc = DetectionSceneVC(with: viewModel)
            router.push(vc, animated: true)
        default:
            showAlert()
        }
    }
    
    private func showTrueDepthScene() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            let vc = DepthDataViewController()
            router.push(vc, animated: true)
        default:
            showAlert()
        }
    }
    
    private func showNavigationTest() {
        let viewModel = MainListViewModel()
        viewModel.mainListDataSource.append(NavigationItem(name: "Face detection scene", link: { [weak self] in
            self?.showDetectionScene()
        }))
        viewModel.mainListDataSource.append(NavigationItem(name: "Point to cloud scene", link: { [weak self] in
            self?.showTrueDepthScene()
        }))
        let main = MainListViewController(with: viewModel)
        router.setToRootModule(main, animated: true)
    }
}
