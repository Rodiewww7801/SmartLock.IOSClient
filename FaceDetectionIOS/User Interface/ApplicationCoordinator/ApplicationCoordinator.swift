//
//  ApplicationCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation

final class ApplicationCoordinator: Coordinator {
    let coordinatorFactory: ApplicationCoordinatorFactory = ApplicationCoordinatorFactory()
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        startMainScene()
    }
    
    private func startMainScene() {
        let coordinator = coordinatorFactory.makeMainCoordinator(router: self.router)
        addChild(coordinator)
        coordinator.start()
    }
}
