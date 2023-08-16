//
//  MainListCoordinator.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 01.04.2023.
//

import Foundation
import AVFoundation
import UIKit

final class MainListSceneCoordinator: Coordinator, MainListSceneCoordinatorOutput {
    private let router: Router
    private var alert: FDAlert?
    
    var logout: (() -> ())?
    
    init(router: Router) {
        self.router = router
        
        print("[MainListCoordinator]: init")
    }
    
    deinit {
        print("[MainListCoordinator]: deinit")
    }
    
    override func start() {
        self.showNavigationTest()
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
        let detectionSceneCoordinator = DetectionSceneCoordinator(router: self.router)
        detectionSceneCoordinator.removeCoordinator = { [weak self, weak detectionSceneCoordinator] in
            guard let detectionSceneCoordinator = detectionSceneCoordinator else { return }
            self?.removeChild(detectionSceneCoordinator)
        }
        self.addChild(detectionSceneCoordinator)
        detectionSceneCoordinator.start()
    }
    
    private func showTrueDepthScene() {
        let pointCloudCor = PointCloudSceneCoordinator(router: self.router)
        pointCloudCor.removeCoordinator = { [weak self, weak pointCloudCor] in
            guard let pointCloudCor = pointCloudCor else { return }
            self?.removeChild(pointCloudCor)
        }
        self.addChild(pointCloudCor)
        pointCloudCor.start()
    }
    
    private func showCreateUserScene() {
        let viewModel = CreateUserViewModel()
        let viewController = UserCreateViewController(with: viewModel)
        router.push(viewController, animated: true)
    }
    
    private func showUserInfoScene() {
        let userInfoViewModel = UserInfoViewModel()
        let userInfoViewController = UserInfoViewController(with: userInfoViewModel)
        router.push(userInfoViewController, animated: true)
    }
    
    private func showUsersListScene() {
        let userListViewModel = UserListViewModel()
        let userListViewController = UserListViewController(with: userListViewModel)
        router.push(userListViewController, animated: true)
    }
    
    private func showNavigationTest() {
        let viewModel = MainListViewModel()
        viewModel.showDetectionScene = self.showDetectionScene
        viewModel.showPointToCloudScene = self.showTrueDepthScene
        viewModel.createUserScene =  self.showCreateUserScene
        viewModel.logout =  self.logout
        viewModel.usersListScene = self.showUsersListScene
        viewModel.showUserInfoScene = self.showUserInfoScene
        let main = MainListViewController(with: viewModel)
        router.setToRootModule(main, animated: true)
    }
}
