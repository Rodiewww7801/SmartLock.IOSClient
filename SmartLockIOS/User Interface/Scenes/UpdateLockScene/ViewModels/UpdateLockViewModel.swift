//
//  UpdateLockViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

class UpdateLockViewModel {
    private var updateLockCommand: UpdateLockCommandProtocol
    private var updateSecretInfoLockCommand: UpdateSecretInfoLockCommandProtocol
    private var createSecretInfoLockCommand: CreateSecretInfoDoorLockCommandProtocol
    var lock: Lock
    var lockSecretInfo: LockSecretInfo?
    
    init(lock: Lock, lockSecretInfo: LockSecretInfo?) {
        self.lock = lock
        self.lockSecretInfo = lockSecretInfo
        self.updateLockCommand = CommandsFactory.createUpdateLockCommand()
        self.updateSecretInfoLockCommand = CommandsFactory.createUpdateSecretInfoLockCommand()
        self.createSecretInfoLockCommand = CommandsFactory.createSecretInfoDoorLockCommand()
    }
    
    func updateLock(_ lock: Lock, _ lockSecretInfo: LockSecretInfo, completion: @escaping (Bool)->()) {
        guard let lockId = Int(lock.id) else { return }
        let lockDTO = UpdateLockDTO(name: lock.name, description: lock.description)
        let updateSecretDTO = UpdateSecretLockInfoDTO(id: lockId, serialNumber: lockSecretInfo.serialNumber)
        updateLockCommand.execute(lockId: lockId, lockDTO) { [weak self] result in
            switch result {
            case .success(_):
                self?.updateSecretInfoLockCommand.execute(lockId: String(lockId), updateSecretDTO) { result in
                    switch result {
                    case .success(_):
                        completion(true)
                    case .failure(_):
                        let secretDTO = CreateLockSecretInfoDTO(serialNumber: updateSecretDTO.serialNumber, doorLockId: updateSecretDTO.id)
                        self?.createSecretInfoLockCommand.execute(secretDTO) { result in
                            switch result {
                            case .success(_):
                                completion(true)
                            case .failure(_):
                                completion(false)
                            }
                        }
                    }
                }
            case .failure(_):
                completion(false)
            }
        }
    }
}
