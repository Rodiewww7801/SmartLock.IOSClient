//
//  DeleteAccessLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class DeleteAccessLockCommand: DeleteAccessLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: String, userId: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.deleteAccessLock(lockId: lockId, userId: userId)
        networkingSerivce.request(requestModel, completion)
    }
}
