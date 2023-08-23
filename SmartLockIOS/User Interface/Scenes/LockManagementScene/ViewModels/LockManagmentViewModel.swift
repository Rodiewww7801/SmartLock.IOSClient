//
//  LockManagmentViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class LockManagmentViewModel {
    private let lockRepository: LockRepositoryProtocol
    private let deleteLockByLockId: DeleteLockCommandProtocol
    private let userRepository: UserRepositoryProtocol
    var lockId: String
    var lock: Lock?
    
    init(lockId: String) {
        self.lockId = lockId
        self.lockRepository = RepositoryFactory.lockRepository()
        self.deleteLockByLockId = CommandsFactory.deleteLockCommand()
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    func loadData(_ completion: @escaping (Lock)->Void) {
        Task { [weak self] in
            guard let self = self else { return }
            let lock = await self.lockRepository.getLock(lockId: self.lockId)
            self.lock = lock
            guard let lock = lock else { return }
            completion(lock)
        }
    }
    
    func deleteLock(_ completion: @escaping (Bool)->Void) {
        Task { [weak self] in
            guard let self = self else { return }
            self.deleteLockByLockId.execute(lockId: self.lockId) { result in
                switch result {
                case .success(_):
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }
        }
    }
    
    func getCurrentUser(_ completion: @escaping (User)->Void) {
        Task { [weak self] in
            guard let user = await self?.userRepository.getUser() else { return }
            completion(user)
        }
    }
}
