//
//  AddUserLockAccessViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class AddUserLockAccessViewModel {
    private var userRepository: UserRepositoryProtocol
    private var createAccessLockCommand: CreateAccessLockCommandProtocol
    var lockId: String
    var dataSource: [User] = []
    
    init(lockId: String) {
        self.lockId = lockId
        self.userRepository = RepositoryFactory.userRepository()
        self.createAccessLockCommand = CommandsFactory.createAccessLockCommand()
    }
    
    func loadData(_ completion: @escaping ([User])->Void) {
        Task { [weak self] in
            let users = await self?.userRepository.getUsers()
            guard let users = users else { return }
            self?.dataSource = users
            completion(users)
        }
    }
    
    func addUserLockAccess(userId: String, _ completion: @escaping (Bool)->Void) {
        guard let lockId = Int(self.lockId) else { return }
        let dto = CreateAccessLockDTO(userId: userId, doorLockId: lockId, hasAccess: true)
        createAccessLockCommand.execute(dto) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
