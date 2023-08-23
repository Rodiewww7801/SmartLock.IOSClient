//
//  MainListViewModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 07.06.2023.
//

import Foundation



protocol MainListViewModelDelegate {
    var showUserInfoScene: (() -> Void)? { get }
    var usersListScene: (()->Void)? { get }
    var logout: (()->Void)? { get }
    var showLockListScene: (()->Void)? { get }
}

class MainListViewModel: MainListViewModelDelegate {
    var mainListDataSource: [MainListSectionData] = []
    private let logoutCommand: LogoutCommandProtocol
    private let userRepository: UserRepositoryProtocol
    private var user: User?
    
    var showUserInfoScene: (() -> Void)?
    var usersListScene: (()->Void)?
    var logout: (()->Void)?
    var showLockListScene: (()->Void)?
    
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
    
    private func configureDataSourceForMainList() -> [MainListSectionData] {
        guard let user = user else { return [] }
        var mainListDataSource = [MainListSectionData]()
        
        if user.role == .admin {
            var adminDataSource = [MainListData]()
            adminDataSource.append(MainListData(
                name: "User list",
                link: { [weak self] in
                    self?.usersListScene?()
                }
            ))
            mainListDataSource.append(MainListSectionData(section: "Admin section", data: adminDataSource))
            
            var lockDataSource = [MainListData]()
            lockDataSource.append(MainListData(
                name: "Lock list",
                link: { [weak self] in
                    self?.showLockListScene?()
                }
            ))
            mainListDataSource.append(MainListSectionData(section: "Lock section", data: lockDataSource))
        }
        
        var userDataSource = [MainListData]()
        userDataSource.append(MainListData(
            name: "Profile",
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
        mainListDataSource.append(MainListSectionData(section: "User section", data: userDataSource))
        
        return mainListDataSource
    }
}
