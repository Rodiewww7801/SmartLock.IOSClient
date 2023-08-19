//
//  AdminUpdateUserViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

class AdminUpdateUserViewModel: UpdateUserViewModelDelegate {
    private var adminUpdateUserCommand: AdminUpdateUserCommandProtocol
    var userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        self.adminUpdateUserCommand = CommandsFactory.adminUpdateUserCommand()
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
}
