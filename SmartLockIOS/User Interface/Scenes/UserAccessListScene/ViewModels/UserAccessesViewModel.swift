//
//  UserAccessesViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class UserAccessesViewModel {
    private var userRepository: UserRepositoryProtocol
    private var lockRepository: LockRepositoryProtocol
    private var deleteAccessCommand: DeleteAccessLockCommandProtocol
    var lockId: String
    var currentUser: User?
    var dataSource: [UserLockAccess] = []
    
    init(lockId: String) {
        self.lockId = lockId
        self.userRepository = RepositoryFactory.userRepository()
        self.lockRepository = RepositoryFactory.lockRepository()
        self.deleteAccessCommand = CommandsFactory.deleteAccessLockCommand()
    }
    
    func loadData(_ completion: @escaping ([UserLockAccess])->Void) {
        self.getUserLockAccesses(completion)
    }
    
    func getCurrentUser(_ completion: @escaping (User)->Void) {
        Task { [weak self] in
            guard let user = await self?.userRepository.getUser() else { return }
            self?.currentUser = user
            completion(user)
        }
    }
    
    func getUserLockAccesses(_ completion: @escaping ([UserLockAccess]) -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            let userLockAccesses = await self.lockRepository.getUserLockAccesses(lockId: self.lockId)
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
