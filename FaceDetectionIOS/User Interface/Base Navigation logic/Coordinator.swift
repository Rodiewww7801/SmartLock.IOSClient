//
//  Coordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation

//MARK: Coordinator is abstract class
class Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() {
        
    }
    
    func addChild(_ coordinator: Coordinator) {
        guard self.childCoordinators.contains(where: { $0 === coordinator }) else { return } //check if same references
        self.childCoordinators.append(coordinator)
    }
    
    //recursive function
    func removeChild(_ coordiantor: Coordinator) {
        for childCoordinator in coordiantor.childCoordinators {
            childCoordinator.childCoordinators.forEach({ childCoordinator.removeChild($0)})
        }
        
        childCoordinators.removeAll()
    }
    
    func removeAllChildren() {
        guard !childCoordinators.isEmpty else { return }
        childCoordinators.removeAll()
    }
}
