//
//  ApplicationCoordinatorFactory.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation

class ApplicationCoordinatorFactory {
    func makeMainCoordinator(router: Router) -> Coordinator {
        return DetectionCoordinator(router: router)
    }
}
