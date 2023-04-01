//
//  DetectionCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation

final class DetectionCoordinator: Coordinator {
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        showDetectionScene()
    }
    
    private func showDetectionScene() {
        let viewModel = DetectionSceneViewModel()
        let vc = DetectionSceneVC(with: viewModel)
        router.setToRootModule(vc, animated: true)
    }
}
