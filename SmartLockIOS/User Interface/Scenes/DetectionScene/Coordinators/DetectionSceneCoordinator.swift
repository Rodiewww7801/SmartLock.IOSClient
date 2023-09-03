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
    
    private var detectionSceneViewModel: DetectionSceneViewModel?
    
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
    
    private func showDetectionScene(lockId: String) {
        let detectionSceneViewModel = DetectionSceneViewModel(lockId: lockId)
        let detectionScene = DetectionSceneVC(with: detectionSceneViewModel)
        detectionScene.showSettings = { [weak self, weak detectionScene] in
            self?.showDetecetionSceneSettingsViewController(delegate: detectionScene)
        }
        detectionScene.showUserCard = { [weak self, weak detectionScene] user in
            guard let detectionScene = detectionScene else { return }
            self?.showUserCard(user: user, on: detectionScene)
        }
        detectionScene.showDetectionPermission = showAlert
        self.detectionSceneViewModel = detectionSceneViewModel
        router.push(detectionScene, animated: true)
    }
    
    private func showDepthData() {
        let depthDataViewController = PointCloudViewController()
        depthDataViewController.onBackTapped = { [weak self] in
            self?.removeCoordinator?()
        }
        depthDataViewController.showSettings = { [weak self] in
            self?.showDepthDataSettings()
        }
        router.push(depthDataViewController, animated: true)
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
    
    private func showDetecetionSceneSettingsViewController(delegate: DetectionSceneSettingsDelegate?) {
        guard let detectionSceneViewModel = detectionSceneViewModel else { return } // todo: fix it pls
        let detecetionSceneSettingsViewController = DetecetionSceneSettingsViewController(with: detectionSceneViewModel)
        detecetionSceneSettingsViewController.delegate = delegate
        router.push(detecetionSceneSettingsViewController, animated: true)
    }
    
    
    private func showDepthDataSettings() {
        let depthDataSettings = PointCloudSceneSettingsViewController()
        router.push(depthDataSettings, animated: true)
    }
    
    private func showLockListScene() {
        let viewModel = LockListViewModel()
        let viewController = LockListViewController(with: viewModel)
        viewController.onBackTapped = { [weak self] in
            self?.removeCoordinator?()
        }
        viewController.onLockSelected = { [weak self] lockId in
            self?.showDetectionScene(lockId: lockId)
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
