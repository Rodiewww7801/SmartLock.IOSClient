//
//  DetectionSceneCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 09.06.2023.
//

import UIKit
import AVFoundation

class DetectionSceneCoordinator: Coordinator {
    
    let router: Router
    var alert: FDAlert?
    var removeCoordinator: (()->())?
    
    private var detectionSettingsViewModel = DetectionSettingsViewModel()
    private var currentLockId: String?
    
    init(router: Router) {
        self.router = router
        print("[DetectionSceneCoordinator]: init")
    }
    
    deinit {
        print("[DetectionSceneCoordinator]: deinit")
    }
    
    override func start() {
        showLockListScene()
    }
    
    private func replaceViewControllerInNavigationStack(from index: Array<UIViewController>.Index, to newVC: UIViewController) {
        let pointToCloudIndexInStack = index
        var viewControllers = router.rootController.viewControllers
        viewControllers[pointToCloudIndexInStack] = newVC
        router.rootController.setViewControllers(viewControllers, animated: false)
    }
    
    private func showDetectionScene() {
        guard let lockId = currentLockId else { return }
        let detectionSceneViewModel = DetectionSceneViewModel(lockId: lockId)
        let detectionScene = DetectionSceneVC(with: detectionSceneViewModel)
        
        detectionScene.showSettings = { [weak self] in
            self?.showDetecetionSceneSettingsViewController()
        }
        
        detectionScene.showUserCard = { [weak self, weak detectionScene] user in
            guard let detectionScene = detectionScene else { return }
            self?.showUserCard(user: user, on: detectionScene)
        }
        
        detectionScene.showDetectionPermission = showAlert
        
        self.detectionSettingsViewModel.onDebugActionSwitch = { [weak detectionSceneViewModel] value in
            detectionSceneViewModel?.debugModeEnabled = value
        }
        
        if let pointToCloudIndexInStack = router.rootController.viewControllers.firstIndex(where: { $0 is PointCloudViewController }) {
            replaceViewControllerInNavigationStack(from: pointToCloudIndexInStack, to: detectionScene)
        } else {
            self.router.push(detectionScene, animated: true)
        }
    }
    
    private func showPointToCloudScene() {
        let depthDataViewController = PointCloudViewController()
        depthDataViewController.showSettings = { [weak self] in
            self?.showDetecetionSceneSettingsViewController()
        }
        
        if let detectionSceneIndexInStack = router.rootController.viewControllers.firstIndex(where: { $0 is DetectionSceneVC }) {
            replaceViewControllerInNavigationStack(from: detectionSceneIndexInStack, to: depthDataViewController)
        } else {
            self.router.push(depthDataViewController, animated: true)
        }
    }
    
    private func pickDetectionScene() {
        if detectionSettingsViewModel.model.pointToCloudState {
            self.showPointToCloudScene()
        } else {
            self.showDetectionScene()
        }
    }
    
    private func showAlert() {
        router.pop(animated: true)
        self.alert = FDAlert()
            .createWith(title: "Error", message: "FaceDetection app doesn't have permission to use the camera, please change privacy settings")
            .addAction(title: "Settings", style: .default, handler: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                          options: [:],
                                          completionHandler: nil)
            })
            .addAction(title: "Close", style: .destructive, handler: nil)
            .present(on: router)
    }
    
    private func showDetecetionSceneSettingsViewController() {
        let detectionSettingsViewController = DetecetionSettingsViewController(viewModel: self.detectionSettingsViewModel)
        self.detectionSettingsViewModel.onPointToCloudSwitch = { [weak self] value in
            self?.pickDetectionScene()
        }
        router.push(detectionSettingsViewController, animated: true)
    }
    
    private func showLockListScene() {
        let viewModel = LockListViewModel()
        let viewController = LockListViewController(with: viewModel)
        viewController.onBackTapped = { [weak self] in
            self?.removeCoordinator?()
        }
        viewController.onLockSelected = { [weak self] lockId in
            self?.currentLockId = lockId
            self?.pickDetectionScene()
        }
        router.push(viewController, animated: true)
    }
    
    private func showUserCard(user: UserCardModel, on presenteViewController: ModalPresentedViewDelegate) {
        let viewModel = UserCardViewModel(user: user)
        let modalViewController = UserCardViewController(with: viewModel)
        modalViewController.modalDelegate = presenteViewController
        self.router.present(modalViewController, animated: true)
    }
}
