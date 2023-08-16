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
    var logout: (()->Void)? { get }
}

class MainListViewModel: MainListViewModelDelegate {
    var mainListDataSource: [MainListData] = []
    private let logoutCommand: LogoutCommandProtocol
    private let userRepository: UserRepositoryProtocol
    private var user: User?
    
    var showDetectionScene: (()->Void)?
    var showPointToCloudScene: (()->Void)?
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
    
    private func configureDataSourceForMainList() -> [MainListData] {
        guard let user = user else { return [] }
        
        var mainListDataSource = [MainListData]()
        mainListDataSource.append(MainListData(
            name: "Face detection scene",
            link: { [weak self] in
                self?.showDetectionScene?()
            }))
        mainListDataSource.append(MainListData(
            name: "Point cloud scene",
            link: { [weak self] in
                self?.showPointToCloudScene?()
            }))
        mainListDataSource.append(MainListData(
            name: "User info",
            link: { [weak self] in
                self?.showUserInfoScene?()
            }
        ))
        mainListDataSource.append(MainListData(
            name: "Logout",
            link: { [weak self] in
                self?.logoutCommand.execute { _ in
                    self?.logout?()
                }
            }))
        return mainListDataSource
    }
}
