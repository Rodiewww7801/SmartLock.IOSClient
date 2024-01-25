//
//  GetLockSecretInfoCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

class GetLockSecretInfoCommand: GetLockSecretInfoCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: String, _ completion: @escaping (Result<SecretLockInfoDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getDoorLockSecretInfo(lockId: lockId)
        networkingSerivce.authRequest(requestModel, completion)
    }
}
