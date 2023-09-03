//
//  UpdateSecretInfoLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

class UpdateSecretInfoLockCommand: UpdateSecretInfoLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: String, _ dto: UpdateSecretLockInfoDTO, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.updateSecretLockInfo(lockId: lockId, dto)
        networkingSerivce.request(requestModel, completion)
    }
}
