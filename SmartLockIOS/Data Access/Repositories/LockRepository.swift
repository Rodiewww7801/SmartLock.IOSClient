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
    private let getUserAccessesByUserIdCommand: GetUserAccessesByUserIdCommandProtocol
    private let getDoorLockHistoryByUserIdCommand: GetDoorLockHistoryByUserIdCommandProtocol
    private let getDoorLockHistoryByDoorLockIdCommand: GetDoorLockHistoryByDoorLockIdCommandProtocol
    private let getLockSecretInfoCommand: GetLockSecretInfoCommandProtocol
    private var userRepository: UserRepositoryProtocol {
        return RepositoryFactory.userRepository()
    }
    
    init() {
        self.getLocksCommand = CommandsFactory.getLocksCommand()
        self.getLockByIdCommand = CommandsFactory.getLockByIdCommand()
        self.getUserAccessesByLockIdCommand = CommandsFactory.getUserAccessesByLockIdCommand()
        self.getUserAccessesByUserIdCommand = CommandsFactory.getUserAccessesByUserIdCommand()
        self.getDoorLockHistoryByUserIdCommand = CommandsFactory.getDoorLockHistoryByUserIdCommand()
        self.getDoorLockHistoryByDoorLockIdCommand = CommandsFactory.getDoorLockHistoryByDoorLockIdCommand()
        self.getLockSecretInfoCommand = CommandsFactory.createGetLockSecretInfoCommand()
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
    
    func getLockSecretInfo(lockId: String) async -> LockSecretInfo? {
        let lockSecretInfoDTO = try? await withUnsafeThrowingContinuation { [weak self] continuatuion in
            self?.getLockSecretInfoCommand.execute(lockId: lockId) { result in
                continuatuion.resume(with: result)
            }
        }
        guard let lockSecretInfoDTO = lockSecretInfoDTO else { return nil }
        let lockSecretInfo = LockSecretInfo(serialNumber: lockSecretInfoDTO.serialNumber)
        return lockSecretInfo
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
                return UserLockAccess(id: String(dto.id), user: user, lock: lock, hasAccess: dto.hasAccess)
            } else {
                return nil
            }
        }
        return userAccesses
    }
    
    func getUserLockAccesses(userId: String) async -> [UserLockAccess] {
        let userAccessDTOTask = Task { [weak self] in
            return try? await withUnsafeThrowingContinuation { continuatuion in
                self?.getUserAccessesByUserIdCommand.execute(userId: userId) { result in
                    continuatuion.resume(with: result)
                }
            }
        }
        
        let getUserTask = Task { [weak self] in
            return await self?.userRepository.getUser(id: userId)
        }
        
        let getLocksTask = Task { [weak self] in
            return await self?.getLocks()
        }
        
        let userAccessDTO = await userAccessDTOTask.value
        let user = await getUserTask.value
        let locks = await getLocksTask.value
        
        guard let user = user, let userAccessDTO = userAccessDTO, let locks = locks else { return [] }
        
        let userAccesses = userAccessDTO.accessesDoorLock.compactMap { dto in
            if let lock = locks.first(where: { String(dto.doorLockId) == $0.id }) {
                return UserLockAccess(id: String(dto.id), user: user, lock: lock, hasAccess: dto.hasAccess)
            } else {
                return nil
            }
        }
        return userAccesses
    }
    
    func getLockHistories(lockId: String) async -> [LockHistory] {
        let lockHistoriesDTOTask = Task { [weak self] in
            return try? await withUnsafeThrowingContinuation { continuatuion in
                self?.getDoorLockHistoryByDoorLockIdCommand.execute(lockId: lockId) { result in
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
        
        let lockHistoriesDTO = await lockHistoriesDTOTask.value
        let users = await getUsersTask.value
        let lock = await getLockTask.value
        
        guard let lock = lock, let lockHistoriesDTO = lockHistoriesDTO, let users = users else { return [] }
        
        let lockHistrories = lockHistoriesDTO.doorLockHistories.compactMap { dto in
            if let user = users.first(where: { $0.id == dto.userId }) {
                return LockHistory(id: String(dto.id), user: user, lock: lock, openedDataTime: Date.convertDateFormat(dto.openedDateTime))
            }
            return nil
        }
        return lockHistrories
    }
    
    func getLockHistories(userId: String) async -> [LockHistory] {
        let lockHistoriesDTOTask = Task { [weak self] in
            return try? await withUnsafeThrowingContinuation { continuatuion in
                self?.getDoorLockHistoryByUserIdCommand.execute(userId: userId) { result in
                    continuatuion.resume(with: result)
                }
            }
        }
        
        let getUserTask = Task { [weak self] in
            return await self?.userRepository.getUser(id: userId)
        }
        
        let getLocksTask = Task { [weak self] in
            return await self?.getLocks()
        }
        
        let lockHistoriesDTO = await lockHistoriesDTOTask.value
        let user = await getUserTask.value
        let locks = await getLocksTask.value
        
        guard let user = user, let lockHistoriesDTO = lockHistoriesDTO, let locks = locks else { return [] }
        
        let lockHistrories = lockHistoriesDTO.doorLockHistories.compactMap { dto in
            if let lock = locks.first(where: { $0.id == String(dto.doorLockId) }) {
                return LockHistory(id: String(dto.id), user: user, lock: lock, openedDataTime: Date.convertDateFormat(dto.openedDateTime))
            }
            return nil
        }
        return lockHistrories
    }
}
