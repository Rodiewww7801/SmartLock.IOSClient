//
//  UserListSceneCoordinator.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import Foundation

class UserListSceneCoordinator: Coordinator {
    let router: Router
    
    var removeCoordinator: (()->())?
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        showUsersListScene()
    }
    
    private func showUsersListScene() {
        let userListViewModel = UserListViewModel()
        let userListViewController = UserListViewController(with: userListViewModel)
        userListViewController.onBackTapped = { [weak self] in
            self?.removeCoordinator?()
        }
        userListViewController.onUserSelected = { [weak self] userId in
            self?.showUserManagmentScene(userId: userId)
        }
        router.push(userListViewController, animated: true)
    }
    
    private func showUserManagmentScene(userId: String) {
        let viewModel = UserManagmentViewModel(userId: userId)
        let viewController = UserManagmentViewController(with: viewModel)
        viewController.onGetUserPhotosAction = showPhotoListScene
        viewController.onDeleteUserAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        router.push(viewController, animated: true)
    }
    
    private func showPhotoListScene(_ userId: String) {
        let viewModel = PhotoListViewModel(userId: userId)
        let viewController = PhotoListViewController(with: viewModel)
        router.push(viewController, animated: true)
    }
}
