//
//  CreateLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

class CreateLockCommand: CreateLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ dto: CreateLockRequestDTO, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.createLock(dto)
        networkingSerivce.request(requestModel, completion)
    }
}
