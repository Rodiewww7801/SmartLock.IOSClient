//
//  ApplicationCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation

final class ApplicationCoordinator: Coordinator {
    let router: Router
    private var authTokenRepository: AuthTokenRepositoryProtocol
    private var isUserLoggedIn = false
    
    init(router: Router) {
        self.authTokenRepository = RepositoryFactory.authTokenRepository()
        if let _ = authTokenRepository.getToken(for: .accessTokenKey) {
            self.isUserLoggedIn = true
        }
        self.router = router
        super.init()
        
        subscribeOnTokenManager()
    }
    
    override func start() {
        if isUserLoggedIn {
            mainListScene()
        } else {
            authenticationScene()
        }
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
}

extension ApplicationCoordinator: TokenListener {
    func refreshTokenExpired() {
        DispatchQueue.main.async { [weak self] in
            self?.removeAllChildren()
            self?.authenticationScene()
        }
    }
    
    private func subscribeOnTokenManager() {
        let tokenObservable = NetworkingFactory.tokenObservable()
        tokenObservable.subscribeListener(self)
    }
}
