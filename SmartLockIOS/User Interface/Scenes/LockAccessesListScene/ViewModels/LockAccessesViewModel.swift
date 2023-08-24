//
//  LockAccessesViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

class LockAccessesViewModel {
    private var userRepository: UserRepositoryProtocol
    private var lockRepository: LockRepositoryProtocol
    private var deleteAccessCommand: DeleteAccessLockCommandProtocol
    var userId: String
    var currentUser: User?
    var dataSource: [UserLockAccess] = []
    
    init(userId: String) {
        self.userId = userId
        self.userRepository = RepositoryFactory.userRepository()
        self.lockRepository = RepositoryFactory.lockRepository()
        self.deleteAccessCommand = CommandsFactory.deleteAccessLockCommand()
    }
    
    func loadData(_ completion: @escaping ([UserLockAccess])->Void) {
        self.getUserLockAccesses(completion)
    }
    
    func getCurrentUser(_ completion: @escaping (User)->Void) {
        Task { [weak self] in
            guard let self = self else { return }
            guard let user = await self.userRepository.getUser() else { return }
            self.currentUser = user
            completion(user)
        }
    }
    
    func getUserLockAccesses(_ completion: @escaping ([UserLockAccess]) -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            let userLockAccesses = await self.lockRepository.getUserLockAccesses(userId: self.userId)
            self.dataSource = userLockAccesses
            completion(userLockAccesses)
        }
    }
    
    func deleteUserLockAccess(lockId: String, userId: String, _ completion: @escaping (Bool)->Void) {
        deleteAccessCommand.execute(lockId: lockId, userId: userId) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
