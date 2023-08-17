//
//  GetUserByIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class GetUserByIdCommand: GetUserByIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, _ completion: @escaping (Result<UserDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.createAdminGetUserRequest(userId: userId)
        networkingSerivce.request(requestModel, completion)
    }
}
