//
//  UpdateUserViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

protocol UpdateUserViewModelDelegate {
    var userInfo: UserInfo { get }
    func updateUser(_ user: User, completion: @escaping (Bool)->())
    func getCurrentUser(_ completion: @escaping (User?)->())
}

class UpdateUserViewModel: UpdateUserViewModelDelegate {
    private var userRepository: UserRepositoryProtocol
    private var updateUserCommand: UpdateUserCommandProtocol
    var userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.updateUserCommand = CommandsFactory.updateUserCommand()
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    func updateUser(_ user: User, completion: @escaping (Bool)->()) {
        updateUserCommand.execute(user: user) { result in
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
