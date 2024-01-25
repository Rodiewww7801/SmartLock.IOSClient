//
//  GetLockByIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class GetLockByIdCommand: GetLockByIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: String, _ completion: @escaping (Result<LockDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getLockById(lockId: lockId)
        networkingSerivce.authRequest(requestModel, completion)
    }
}
