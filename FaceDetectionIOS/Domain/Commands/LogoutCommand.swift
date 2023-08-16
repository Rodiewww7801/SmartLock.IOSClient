//
//  LogoutCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class LogoutCommand: LogoutCommandProtocol {
    private var authTokenRepository: AuthTokenRepositoryProtocol
    private var networkingService: NetworkingServiceProotocol
    
    init() {
        self.authTokenRepository = RepositoryFactory.authTokenRepository()
        self.networkingService = NetworkingFactory.networkingService()
    }
    
    func execute(_ comletion: @escaping (Result<Bool,Error>) -> ()) {
        guard let accessToken = authTokenRepository.getToken(for: .accessTokenKey),
            let refreshToken = authTokenRepository.getToken(for: .refreshTokenKey),
            let requestModel = FaceLockAPIRequestFactory.createLogoutRequest(accessToken: accessToken, refreshToken: refreshToken)
        else {
            return
        }
        networkingService.request(requestModel) { [weak self] result in
            switch result {
            case .success(_):
                print("[LogoutCommand] SUCCESS perform logout requset")
            case .failure(_):
                print("[LogoutCommand] FAILED perform logout request")
            }
            self?.authTokenRepository.removeToken(for: .accessTokenKey)
            self?.authTokenRepository.removeToken(for: .refreshTokenKey)
            comletion(.success(true))
        }
    }
}
