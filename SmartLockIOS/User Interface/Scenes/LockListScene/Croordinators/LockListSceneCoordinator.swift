//
//  LockListSceneCoordinator.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

class LockListSceneCoordinator: Coordinator {
    let router: Router
    
    var removeCoordinator: (()->())?
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        showLockListScene()
    }
    
    private func showLockListScene() {
        let viewModel = AdminLockListViewModel()
        let viewController = LockListViewController(with: viewModel)
        viewController.onBackTapped = { [weak self] in
            self?.removeCoordinator?()
        }
        viewController.onAddButtonAction = { [weak self, weak viewController] in
            guard let viewController = viewController else { return }
            self?.showLockCreationScene(on: viewController)
        }
        viewController.onLockSelected = { [weak self] lockId in
            self?.showLockManagementScene(lockId: lockId)
        }
        router.push(viewController, animated: true)
    }
    
    private func showLockManagementScene(lockId: String) {
        let viewModel = LockManagmentViewModel(lockId: lockId)
        let viewController = LockManagmentViewController(with: viewModel)
        viewController.onDeleteAction = { [weak self] in
            self?.router.pop(animated: true)
        }
        viewController.onGetUserLockAccessesAction = showUserLockAccessList
        viewController.onGetHistroriesAction = showLockHistoriesScene
        router.push(viewController, animated: true)
    }
    
    
    private func showLockCreationScene(on presenteViewController: ModalPresentedViewDelegate) {
        let viewModal = AddLockViewModel()
        let modalViewController = AddLockViewController(with: viewModal)
        modalViewController.modalDelegate = presenteViewController
        self.router.present(modalViewController, animated: true)
    }
    
    private func showUserLockAccessList(lockId: String) {
        let viewModel = UserAccessesViewModel(lockId: lockId)
        let viewController = UserAccessesListViewController(with: viewModel)
        viewController.onAddButtonAction = { [weak self, weak viewController] in
            guard let viewController = viewController else { return }
            self?.showAddAccessScene(lockId: lockId, on: viewController)
        }
        self.router.push(viewController, animated: true)
    }
    
    private func showAddAccessScene(lockId: String, on presenteViewController: ModalPresentedViewDelegate) {
        let viewModal = AddUserLockAccessViewModel(lockId: lockId)
        let modalViewController = AddUserLockAccessViewController(with: viewModal)
        modalViewController.modalDelegate = presenteViewController
        self.router.present(modalViewController, animated: true)
    }
    
    private func showLockHistoriesScene(lockId: String) {
        let viewModel = UserHistoryViewModel(lockId: lockId)
        let viewControllet = UserHistroryViewController(with: viewModel)
        self.router.push(viewControllet, animated: true)
    }
}
