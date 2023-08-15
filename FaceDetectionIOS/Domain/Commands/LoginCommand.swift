//
//  LoginCommand.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

class LoginCommand: LoginCommandProtocol {
    private let networkingSerivce: NetworkingServiceProotocol
    private let authTokenRepository: AuthTokenRepositoryProtocol
    
    init() {
        self.authTokenRepository = RepositoryFactory.authTokenRepository()
        self.networkingSerivce = NetworkingServiceFactory.networkingService()
    }
    
    func execute(with model: LoginRequestDTO, _ completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let requestModel = FaceLockAPIRequestFactory.createLoginRequest(model) else { return }
        networkingSerivce.request(requestModel) { [weak self] (result: Result<LoginResponseDTO, Error>) in
            switch result {
            case .success(let success):
                self?.saveToStorage(accessToken: success.accessToken, refreshToken: success.refreshToken)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func saveToStorage(accessToken: String, refreshToken: String) {
        authTokenRepository.setToken(accessToken, for: .accessTokenKey)
        authTokenRepository.setToken(refreshToken, for: .refreshTokenKey)
    }
}
