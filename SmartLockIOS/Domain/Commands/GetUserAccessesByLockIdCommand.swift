//
//  GetUserAccessesByLockIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

class GetUserAccessesByLockIdCommand: GetUserAccessesByLockIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: String, _ completion: @escaping (Result<GetUserLockAccessResponseDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getUserAccessesByLockId(lockId: lockId)
        networkingSerivce.request(requestModel, completion)
    }
}
