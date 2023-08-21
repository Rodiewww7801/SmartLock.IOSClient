//
//  ApplicationCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation
import UIKit

final class ApplicationCoordinator: Coordinator {
    private let router: Router
    private var alert: FDAlert?
    private var authTokenRepository: AuthTokenRepositoryProtocol
    private var isUserLoggedIn: Bool {
        if let _ = authTokenRepository.getToken(for: .accessTokenKey) {
            return true
        }
        return false
    }
    
    init(router: Router) {
        self.authTokenRepository = RepositoryFactory.authTokenRepository()
        self.router = router
        super.init()
        subscribeOnTokenPublisher()
        subscribeNetworkingPublisher()
    }
    
    override func start() {
        initialScene()
    }
    
    private func authenticationScene() {
        let authenticationCoordinator = AuthenticationSceneCoordinator(router: router)
        authenticationCoordinator.showMainView = { [weak self] in
            self?.removeChild(authenticationCoordinator)
            authenticationCoordinator.removeAllChildren()
            self?.mainListScene()
        }
        self.childCoordinators.append(authenticationCoordinator)
        authenticationCoordinator.start()
    }
    
    private func mainListScene() {
        let mainListCoordinator = MainListSceneCoordinator(router: router)
        mainListCoordinator.logout = { [weak self] in
            mainListCoordinator.removeAllChildren()
            self?.removeChild(mainListCoordinator)
            DispatchQueue.main.async {
                self?.authenticationScene()
            }
        }
        self.childCoordinators.append(mainListCoordinator)
        mainListCoordinator.start()
    }
    
    private func initialScene() {
        let viewController = InitialViewController()
        viewController.onSmartLockAction = { [weak self] in
            self?.showDetectionScene()
        }
        viewController.onProfileAction = { [weak self] in
            if self?.isUserLoggedIn == true {
                self?.mainListScene()
            } else {
                self?.authenticationScene()
            }
        }
        router.setToRootModule(viewController, animated: true)
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
        let coordinator = DetectionSceneCoordinator(router: self.router)
        coordinator.removeCoordinator = {  [weak self, weak coordinator] in
            guard let coordinator = coordinator else { return }
            self?.removeChild(coordinator)
        }
        self.addChild(coordinator)
        coordinator.start()
    }
}

extension ApplicationCoordinator: TokenListener {
    func refreshTokenExpired() {
        DispatchQueue.main.async { [weak self] in
            self?.removeAllChildren()
            self?.authenticationScene()
        }
    }
    
    private func subscribeOnTokenPublisher() {
        let tokenPublisher = NetworkingFactory.tokenPublisher()
        tokenPublisher.subscribeListener(self)
    }
}

extension ApplicationCoordinator: NetwrokingListener {
    func receivedError(_ error: NetworkingError) {
        DispatchQueue.main.async { [weak self] in
            guard let presentedViewController = self?.router.rootController.topViewController else { return }
            
            FDAlert()
                .createWith(title: error.title, message: error.message)
                .addAction(title: "Try again", style: .default, handler: { [weak self] in
                    switch error {
                    case .authenticationError(_), .refreshTokenExpired(_):
                        self?.refreshTokenExpired()
                    default:break
                    }
                })
                .present(on: presentedViewController)
        }
    }
    
    private func subscribeNetworkingPublisher() {
        let networkingPublisher = NetworkingFactory.networkingPublisher()
        networkingPublisher.subscribeListener(self)
    }
}
