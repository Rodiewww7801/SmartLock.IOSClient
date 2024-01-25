//
//  CreateUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class CreateUserCommand: CreateUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ dto: CreateUserRequestDTO, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let requestModel = FaceLockAPIRequestFactory.adminCreateUserRequest(with: dto) else { return }
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
