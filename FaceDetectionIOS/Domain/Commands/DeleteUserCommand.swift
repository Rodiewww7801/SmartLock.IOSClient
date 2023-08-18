//
//  DeleteUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

class DeleteUserCommand: DeleteUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.createAdminDeleteUserAccount(userId: userId)
        networkingSerivce.request(requestModel, completion)
    }
}
