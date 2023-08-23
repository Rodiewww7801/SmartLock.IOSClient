//
//  AdminUpdateUserViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

class AdminUpdateUserViewModel: UpdateUserViewModelDelegate {
    private var adminUpdateUserCommand: AdminUpdateUserCommandProtocol
    private var userRepository: UserRepositoryProtocol
    var userInfo: User
    
    init(userInfo: User) {
        self.userInfo = userInfo
        self.adminUpdateUserCommand = CommandsFactory.adminUpdateUserCommand()
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    func updateUser(_ user: User, completion: @escaping (Bool)->()) {
        adminUpdateUserCommand.execute(user: user) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func getCurrentUser(_ completion: @escaping (User?)->()) {
        Task { [weak self] in
            let currentUser = await self?.userRepository.getUser()
            completion(currentUser)
        }
    }
}
