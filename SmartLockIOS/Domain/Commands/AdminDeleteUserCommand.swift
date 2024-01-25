//
//  DeleteUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

class AdminDeleteUserCommand: AdminDeleteUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.adminDeleteUserAccount(userId: userId)
        networkingSerivce.authRequest(requestModel, { result in
            switch result {
            case .success(_):
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
