//
//  AddUserLockAccessViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class AddUserLockAccessViewModel {
    private var userRepository: UserRepositoryProtocol
    private var lockRepository: LockRepositoryProtocol
    private var createAccessLockCommand: CreateAccessLockCommandProtocol
    var lockId: String
    var dataSource: [User] = []
    
    init(lockId: String) {
        self.lockId = lockId
        self.userRepository = RepositoryFactory.userRepository()
        self.createAccessLockCommand = CommandsFactory.createAccessLockCommand()
        self.lockRepository = RepositoryFactory.lockRepository()
    }
    
    func loadData(_ completion: @escaping ([User])->Void) {
        
        Task { [weak self] in
            let users = await self?.getUsers()
            guard let users = users else { return }
            self?.dataSource = users
            completion(users)
        }
    }
    
    private func getUsers() async -> [User] {
        let getUsersTask = Task { [weak self] in
            return await self?.userRepository.getUsers()
        }
        
        let getUserLockAccessesTask = Task { [weak self] in
            guard let self = self else { return [UserLockAccess]() }
            return await self.lockRepository.getUserLockAccesses(lockId: self.lockId)
        }
        
        let userLockAccesses = await getUserLockAccessesTask.value
        var users = await getUsersTask.value
        users = users?.filter { user in
            !userLockAccesses.contains(where: { $0.user.id == user.id })
        }
        return users ?? []
    }
    
    func addUserLockAccess(userId: String, _ completion: @escaping (Bool)->Void) {
        guard let lockId = Int(self.lockId) else { return }
        let dto = AccessLockDTO(userId: userId, doorLockId: lockId, hasAccess: true)
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
