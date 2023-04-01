//
//  Router.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation
import UIKit

class Router {
    var rootController: UINavigationController
    
    init(rootController: UINavigationController) {
        self.rootController = rootController
    }
    
    var rootModule: Presentable? {
        return rootController
    }
    
    func present(_ module: Presentable, with animated: Bool) {
        self.rootController.present(module.toPresent(), animated: animated)
    }
    
    func push(_ module: Presentable, animated: Bool) {
        let controller = module.toPresent()
        rootController.pushViewController(controller, animated: animated)
    }
    
    func setToRootModule(_ module: Presentable, animated: Bool) {
        let controller = module.toPresent()
        
        rootController.setViewControllers([controller], animated: animated)
        
        if let rootView = rootController.viewControllers.first?.view {
            rootController.view.bringSubviewToFront(rootView)
        }
    }
    
    func pop(animated: Bool = true) {
        rootController.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        rootController.popToRootViewController(animated: animated)
    }
    
    func popToModule(_ module: Presentable, animated: Bool = true) {
        rootController.popToViewController(module.toPresent(), animated: animated)
    }
}
