//
//  UpdateDoorLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

class UpdateLockCommand: UpdateLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: Int, _ dto: UpdateLockDTO, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.updateLock(lockId: lockId, dto)
        networkingSerivce.request(requestModel, completion)
    }
}
