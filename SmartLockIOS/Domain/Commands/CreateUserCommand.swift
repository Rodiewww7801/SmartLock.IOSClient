//
//  CreateUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class CreateUserCommand: CreateUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ dto: CreateUserRequestDTO, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let requestModel = FaceLockAPIRequestFactory.adminCreateUserRequest(with: dto) else {
            completion(.failure(NetworkingError.failedToCreateRequestModel()))
            return
        }
        networkingSerivce.request(requestModel, completion)
    }
}
