//
//  GetDoorLockHistoryByUserIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

class GetDoorLockHistoryByUserIdCommand: GetDoorLockHistoryByUserIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, _ completion: @escaping (Result<GetLockHistoryDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getLockHistoryByUserId(userId: userId)
        networkingSerivce.request(requestModel, completion)
    }
}
