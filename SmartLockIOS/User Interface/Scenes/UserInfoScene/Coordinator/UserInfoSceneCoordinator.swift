//
//  UserInfoSceneCoordinator.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 20.08.2023.
//

import Foundation

final class UserInfoSceneCoordinator: Coordinator {
    private let router: Router
    private var alert: FDAlert?
    
    var logout: (()->())?
    var removeCoordinator: (()->())?
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        self.showUserInfoScene()
    }
    
    private func showUserInfoScene() {
        let userInfoViewModel = UserInfoViewModel()
        let userInfoViewController = UserInfoViewController(with: userInfoViewModel)
        userInfoViewController.onUpdateUserAction = showUpdateUserScene
        userInfoViewController.onDeleteUserAction = self.logout
        userInfoViewController.onBackTapped = { [weak self] in
            self?.removeCoordinator?()
        }
        router.push(userInfoViewController, animated: true)
    }
    
    private func showUpdateUserScene(_ userInfo: UserInfo) {
        let viewModel = UpdateUserViewModel(userInfo: userInfo)
        let viewController = UpdateUserViewController(with: viewModel)
        viewController.onUserUpdate = { [weak self] in
            self?.router.pop(animated: true)
        }
        self.router.push(viewController, animated: true)
    }
}
