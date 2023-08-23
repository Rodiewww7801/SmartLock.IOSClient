//
//  CreateAccessLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class CreateAccessLockCommand: CreateAccessLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ dto: CreateAccessLockDTO, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.createAccessLock(dto)
        networkingSerivce.request(requestModel, completion)
    }
}
