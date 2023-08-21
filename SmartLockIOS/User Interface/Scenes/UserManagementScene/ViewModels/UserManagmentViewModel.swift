//
//  UserManagmentViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import UIKit

class UserManagmentViewModel {
    var userId: String
    var userInfo: UserInfo?
    var userRepository: UserRepositoryProtocol
    var deleteUserCommand: AdminDeleteUserCommandProtocol
    
    init(userId: String) {
        self.userId = userId
        self.userRepository = RepositoryFactory.userRepository()
        self.deleteUserCommand = CommandsFactory.adminDeleteUserCommand()
    }
    
    func loadData(_ completion: @escaping ()->() ) {
        Task { [weak self] in
            guard let self = self else { return }
            self.userInfo = await self.userRepository.getUsersInfo().first(where: { $0.user.id == self.userId })
            completion()
        }
    }
    
    func deleteUser(_ completion: @escaping ((Bool)->Void)) {
        deleteUserCommand.execute(userId: userId) { result in
            switch result {
            case .success():
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
