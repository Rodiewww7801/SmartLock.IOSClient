//
//  UserInfoViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class UserInfoViewModel {
    var userInfoModel: User?
    private var userRepository: UserRepositoryProtocol
    private var deleteUserCommand: DeleteUserCommandProtocol
    
    init() {
        self.userRepository = RepositoryFactory.userRepository()
        self.deleteUserCommand = CommandsFactory.deleteUserCommand()
    }
    
    func configure(_ completion: @escaping ((User)->Void)) {
        Task { [weak self] in
            let userInfo = await self?.getUserInfo()
            guard let userInfo = userInfo else { return }
            completion(userInfo)
        }
    }
    
    func getUserInfo() async -> User? {
        let userInfo = await self.userRepository.getUser()
        self.userInfoModel = userInfo
        return userInfo
    }
    
    func deleteUser(_ completion: @escaping ((Bool)->Void)) {
        deleteUserCommand.execute() { result in
            switch result {
            case .success():
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
