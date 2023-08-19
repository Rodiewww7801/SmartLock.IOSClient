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
}

class UpdateUserViewModel: UpdateUserViewModelDelegate {
    private var updateUserCommand: UpdateUserCommandProtocol
    var userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.updateUserCommand = CommandsFactory.updateUserCommand()
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
}
