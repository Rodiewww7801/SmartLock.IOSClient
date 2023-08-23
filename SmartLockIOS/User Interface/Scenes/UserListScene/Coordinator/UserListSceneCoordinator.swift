//
//  UserListSceneCoordinator.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import Foundation
import UIKit

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
        userListViewController.onAddButtonAction = { [weak self, weak userListViewController] in
            guard let userListViewController = userListViewController else { return }
            self?.showUserCreationScene(on: userListViewController)
        }
        router.push(userListViewController, animated: true)
    }
    
    private func showUserManagmentScene(userId: String) {
        let viewModel = UserManagmentViewModel(userId: userId)
        let viewController = UserManagmentViewController(with: viewModel)
        viewController.onGetUserPhotosAction = showPhotoListScene
        viewController.onUpdateUserAction = showUpdateUserScene
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
    
    private func showUpdateUserScene(_ userInfo: User) {
        let viewModel = AdminUpdateUserViewModel(userInfo: userInfo)
        let viewController = UpdateUserViewController(with: viewModel)
        viewController.onUserUpdate = { [weak self] in
            self?.router.pop(animated: true)
        }
        self.router.push(viewController, animated: true)
    }
    
    private func showUserCreationScene(on presenteViewController: ModalPresentedViewDelegate) {
        let viewModal = CreateUserViewModel()
        let modalViewController = UserCreateViewController(with: viewModal)
        modalViewController.modalDelegate = presenteViewController
        self.router.present(modalViewController, animated: true)
    }
}
