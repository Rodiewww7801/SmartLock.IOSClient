//
//  MainListCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation

final class MainListSceneCoordinator: Coordinator {
    private let router: Router
    
    var logout: (() -> ())?
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        self.showMainList()
    }
    
    private func showUserInfoScene() {
        let coordinator = UserInfoSceneCoordinator(router: self.router)
        coordinator.logout = logout
        coordinator.removeCoordinator = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else { return }
            self?.removeChild(coordinator)
        }
        self.addChild(coordinator)
        coordinator.start()
    }
    
    private func showLockListScene() {
        let coordinator = LockListSceneCoordinator(router: self.router)
        coordinator.removeCoordinator = { [weak self, weak coordinator] in
            guard let coordinator = coordinator else { return }
            self?.removeChild(coordinator)
        }
        self.addChild(coordinator)
        coordinator.start()
    }
    
    private func showUsersListScene() {
        let userListSceneCoordinator = UserListSceneCoordinator(router: self.router)
        userListSceneCoordinator.removeCoordinator = { [weak self, weak userListSceneCoordinator] in
            guard let userListSceneCoordinator = userListSceneCoordinator else { return }
            self?.removeChild(userListSceneCoordinator)
        }
        self.addChild(userListSceneCoordinator)
        userListSceneCoordinator.start()
    }
    
    private func showMainList() {
        let viewModel = MainListViewModel()
        viewModel.logout =  self.logout
        viewModel.usersListScene = self.showUsersListScene
        viewModel.showUserInfoScene = self.showUserInfoScene
        viewModel.showLockListScene = self.showLockListScene
        let main = MainListViewController(with: viewModel)
        router.popToRoot(animated: false)
        router.push(main, animated: true)
    }
}
