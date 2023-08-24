//
//  GetUserAccessesByUserIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

class GetUserAccessesByUserIdCommand: GetUserAccessesByUserIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, _ completion: @escaping (Result<GetUserLockAccessResponseDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getUserAccessesByUserId(userId: userId)
        networkingSerivce.request(requestModel, completion)
    }
}
