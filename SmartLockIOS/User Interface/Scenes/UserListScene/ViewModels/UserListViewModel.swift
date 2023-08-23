//
//  UserListViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class UserListViewModel {
    private var userRepository: UserRepositoryProtocol
    var currentUser: User?
    var dataSource: [User] = []
    
    init() {
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    
    func loadData(_ completion: @escaping ([User])->Void) {
        Task { [weak self] in
            let users = await self?.userRepository.getUsers()
            guard let users = users else { return }
            self?.dataSource = users
            completion(users)
        }
    }
    
    func getCurrentUser(_ completion: @escaping (User)->Void) {
        Task { [weak self] in
            guard let user = await self?.userRepository.getUser() else { return }
            self?.currentUser = user
            completion(user)
        }
    }
}
