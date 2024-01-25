//
//  CreateSecretInfoDoorLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 29.08.2023.
//

import Foundation

class CreateSecretInfoDoorLockCommand: CreateSecretInfoDoorLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ dto: CreateLockSecretInfoDTO, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.createSecretInfoDoorLock(dto)
        networkingSerivce.authRequest(requestModel, { result in
            switch result {
            case .success(_):
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
