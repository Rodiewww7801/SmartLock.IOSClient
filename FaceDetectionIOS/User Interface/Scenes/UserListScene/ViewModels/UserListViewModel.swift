//
//  UserListViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class UserListViewModel {
    private var userRepository: UserRepositoryProtocol
    var dataSource: [UserInfo] = []
    
    init() {
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    
    func loadData(_ completion: @escaping ([UserInfo])->Void) {
        Task { [weak self] in
            let users = await self?.userRepository.getUserInfo()
            guard let users = users else { return }
            self?.dataSource = users
            completion(users)
        }
    }
}
