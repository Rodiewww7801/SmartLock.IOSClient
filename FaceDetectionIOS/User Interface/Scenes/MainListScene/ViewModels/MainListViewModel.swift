//
//  MainListViewModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 07.06.2023.
//

import Foundation

struct MainListData {
    var name: String
    var link: (()->())?
}

protocol MainListViewModelDelegate {
    var showDetectionScene: (()->Void)? { get }
    var showPointToCloudScene: (()->Void)? { get }
    var createUserScene: (()->Void)? { get }
    var logout: (()->Void)? { get }
}

class MainListViewModel: MainListViewModelDelegate {
    var mainListDataSource: [String:[MainListData]] = [:]
    private let logoutCommand: LogoutCommandProtocol
    private let userRepository: UserRepositoryProtocol
    private var user: User?
    
    var showDetectionScene: (()->Void)?
    var showPointToCloudScene: (()->Void)?
    var createUserScene: (()->Void)?
    var showUserInfoScene: (() -> Void)?
    var logout: (()->Void)?
    
    init() {
        self.logoutCommand = CommandsFactory.logoutCommand()
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    func configure(_ completion: @escaping (()->Void)) {
        Task {
            self.user = await userRepository.getUser()
            self.mainListDataSource = configureDataSourceForMainList()
            completion()
        }
    }
    
    private func configureDataSourceForMainList() -> [String:[MainListData]] {
        guard let user = user else { return [:] }
        var mainListDataSource = [String:[MainListData]]()
        var faceDetectionDataSource = [MainListData]()
        
        faceDetectionDataSource.append(MainListData(
            name: "Face detection scene",
            link: { [weak self] in
                self?.showDetectionScene?()
            }))
        faceDetectionDataSource.append(MainListData(
            name: "Point cloud scene",
            link: { [weak self] in
                self?.showPointToCloudScene?()
            }))
        mainListDataSource.updateValue(faceDetectionDataSource, forKey: "Face Detection section")
        
        if user.role == .admin {
            var adminDataSource = [MainListData]()
            adminDataSource.append(MainListData(
                name: "Create user",
                link: { [weak self] in
                    self?.createUserScene?()
                }
            ))
            mainListDataSource.updateValue(adminDataSource, forKey: "Admin section")
        }
        
        var userDataSource = [MainListData]()
        userDataSource.append(MainListData(
            name: "User info",
            link: { [weak self] in
                self?.showUserInfoScene?()
            }
        ))
        userDataSource.append(MainListData(
            name: "Logout",
            link: { [weak self] in
                self?.logoutCommand.execute { _ in
                    self?.logout?()
                }
            }))
        mainListDataSource.updateValue(userDataSource, forKey: "User section")
        return mainListDataSource
    }
}
