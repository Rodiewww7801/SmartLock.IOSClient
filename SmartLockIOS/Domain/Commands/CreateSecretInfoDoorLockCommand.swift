//
//  CreateSecretInfoDoorLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 29.08.2023.
//

import Foundation

class CreateSecretInfoDoorLockCommand: CreateSecretInfoDoorLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ dto: LockSecretInfoDTO, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.createSecretInfoDoorLock(dto)
        networkingSerivce.request(requestModel, completion)
    }
}
