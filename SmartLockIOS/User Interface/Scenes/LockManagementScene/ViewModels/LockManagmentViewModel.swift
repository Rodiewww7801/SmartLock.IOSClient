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
    var lockSecretInfo: LockSecretInfo?
    
    init(lockId: String) {
        self.lockId = lockId
        self.lockRepository = RepositoryFactory.lockRepository()
        self.deleteLockByLockId = CommandsFactory.deleteLockCommand()
        self.userRepository = RepositoryFactory.userRepository()
    }
    
    func loadData(_ completion: @escaping (Lock, LockSecretInfo?)->Void) {
        Task { [weak self] in
            guard let self = self else { return }
            
            let lockTask = Task.detached {
                return await self.lockRepository.getLock(lockId: self.lockId)
            }
            
            let lockSecretInfoTask = Task.detached {
                return await self.lockRepository.getLockSecretInfo(lockId: self.lockId)
            }
            
            self.lock = await lockTask.value
            self.lockSecretInfo = await lockSecretInfoTask.value
            guard let lock = lock else { return }
            completion(lock, self.lockSecretInfo)
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
