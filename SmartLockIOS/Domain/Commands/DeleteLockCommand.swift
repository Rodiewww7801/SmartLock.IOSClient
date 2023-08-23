//
//  DeleteLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class DeleteLockCommand: DeleteLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.deleteLockById(lockId: lockId)
        networkingSerivce.request(requestModel, completion)
    }
}
