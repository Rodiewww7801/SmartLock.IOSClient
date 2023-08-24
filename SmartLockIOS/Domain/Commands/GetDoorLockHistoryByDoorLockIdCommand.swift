//
//  GetDoorLockHistoryByDoorLockIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

class GetDoorLockHistoryByDoorLockIdCommand: GetDoorLockHistoryByDoorLockIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: String, _ completion: @escaping (Result<GetLockHistoryDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getLockHistoryByLockId(lockId: lockId)
        networkingSerivce.request(requestModel, completion)
    }
}
