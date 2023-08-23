//
//  LockRepository.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

class LockRepository: LockRepositoryProtocol {
    private let getLocksCommand: GetLocksCommandProtocol
    private let getLockByIdCommand: GetLockByIdCommandProtocol
    private let getUserAccessesByLockIdCommand: GetUserAccessesByLockIdCommandProtocol
    private var userRepository: UserRepositoryProtocol {
        return RepositoryFactory.userRepository()
    }
    
    init() {
        self.getLocksCommand = CommandsFactory.getLocksCommand()
        self.getLockByIdCommand = CommandsFactory.getLockByIdCommand()
        self.getUserAccessesByLockIdCommand = CommandsFactory.getUserAccessesByLockIdCommand()
    }
    
    func getLocks() async -> [Lock] {
       let lockDTOs = try? await withUnsafeThrowingContinuation { [weak self] continuation in
            self?.getLocksCommand.execute { result in
                continuation.resume(with: result)
            }
       }
        
        let locks = lockDTOs?.doorLocks.compactMap({ dto in Lock(id: String(dto.id), name: dto.name, description: dto.description) }) ?? []
        return locks
    }
    
    func getLock(lockId: String) async -> Lock? {
        let lockDTO = try? await withUnsafeThrowingContinuation { [weak self] continuatuion in
            self?.getLockByIdCommand.execute(lockId: lockId) { result in
                continuatuion.resume(with: result)
            }
        }
        guard let lockDTO = lockDTO else { return nil }
        let lock = Lock(id: String(lockDTO.id), name: lockDTO.name, description: lockDTO.description)
        return lock
    }
    
    func getUserLockAccesses(lockId: String) async -> [UserLockAccess] {
        let userAccessDTOTask = Task { [weak self] in
            return try? await withUnsafeThrowingContinuation { continuatuion in
                self?.getUserAccessesByLockIdCommand.execute(lockId: lockId) { result in
                    continuatuion.resume(with: result)
                }
            }
        }
        
        let getUsersTask = Task { [weak self] in
            return await self?.userRepository.getUsers()
        }
        
        let getLockTask = Task { [weak self] in
            return await self?.getLock(lockId: lockId)
        }
        
        let userAccessDTO = await userAccessDTOTask.value
        let users = await getUsersTask.value
        let lock = await getLockTask.value
        
        guard let lock = lock, let userAccessDTO = userAccessDTO, let users = users else { return [] }
        
        let userAccesses = userAccessDTO.accessesDoorLock.compactMap { dto in
            if let user = users.first(where: { dto.userId == $0.id }) {
                return UserLockAccess(
                    id: String(dto.id),
                    user: user,
                    lock: lock,
                    hasAccess: dto.hasAccess)
            } else {
                return nil
            }
        }
        return userAccesses
    }
}
