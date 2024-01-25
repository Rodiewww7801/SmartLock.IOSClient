//
//  DeleteUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

class DeleteUserCommand: DeleteUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    private var authTokenRepository: AuthTokenRepositoryProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
        self.authTokenRepository = RepositoryFactory.authTokenRepository()
    }
    
    func execute(_ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.deleteUser()
        networkingSerivce.authRequest(requestModel) { [weak self] result in
            switch result {
            case .success(_):
                self?.authTokenRepository.removeToken(for: .accessTokenKey)
                self?.authTokenRepository.removeToken(for: .refreshTokenKey)
                completion(.success( () ))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
