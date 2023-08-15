//
//  AuthenticationSceneCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

class AuthenticationSceneCoordinator: Coordinator, AuthenticationSceneCoordinatorOutput {
    let router: Router
    
    var showMainView: (()->Void)?
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        loginScene()
    }
    
    private func loginScene() {
        let viewModel = AuthenticationViewModel()
        let authenticationVC = AuthenticationVC(with: viewModel)
        authenticationVC.onRegisterAction = { [weak self] in
            self?.registrationScene()
        }
        authenticationVC.onLoginAction = { [weak self] in
            self?.showMainView?()
        }
        router.push(authenticationVC, animated: true)
    }
    
    private func registrationScene() {
        let viewModel = RegistrationViewModel()
        let registrationVC = RegistrationVC(with: viewModel)
        registrationVC.onRegisterAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        router.push(registrationVC, animated: true)
    }
}
