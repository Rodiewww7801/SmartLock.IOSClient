//
//  TokenManager.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation


protocol TokenManagerProtocol {
    var accessToken: String? { get }
    func refreshTokenIfNeeded(_ completion: @escaping (Result<Void,NetworkingError>)->Void)
}

class TokenManager: TokenManagerProtocol {
    private var authTokenRepository: AuthTokenRepositoryProtocol
    private var urlSession: URLSession
    
    var accessToken: String? {
        return authTokenRepository.getToken(for: .accessTokenKey)
    }
    
    var refreshToken: String? {
        return authTokenRepository.getToken(for: .refreshTokenKey)
    }
    
    init(urlSession: URLSession) {
        self.authTokenRepository = RepositoryFactory.authTokenRepository()
        self.urlSession = urlSession
    }
    
    func refreshTokenIfNeeded(_ completion: @escaping (Result<Void,NetworkingError>)->Void) {
        let token = decodeToken()
        if let token = token, Date().timeIntervalSince1970 > token.expirationTime {
            print("[TokenManager] token has expired")
            if let refreshToken = refreshToken, let requestModel = FaceLockAPIRequestFactory.refresh(refreshToken: refreshToken) {
                urlSession.request(requestModel) { [weak self] (result: Result<(data: Data?, urlResponse: HTTPURLResponse), Error>) in
                    switch result {
                    case .success(let response):
                        if let data = response.data, let decodedData = try? JSONDecoder().decode(RefreshResponseDTO.self, from: data) {
                            print("[TokenManager] token has updated")
                            self?.authTokenRepository.setToken(decodedData.accessToken, for: .accessTokenKey)
                            completion(.success(Void()))
                        } else {
                            print("[TokenManager] failde to decode token")
                            completion(.failure(NetworkingError.unableToDecode()))
                        }
                    case .failure(_):
                        print("[TokenManager] refresh token has expired")
                        self?.authTokenRepository.removeToken(for: .refreshTokenKey)
                        self?.authTokenRepository.removeToken(for: .accessTokenKey)
                        completion(.failure(NetworkingError.refreshTokenExpired()))
                    }
                }
            }
        } else {
            completion(.success(Void()))
        }
    }
    
    private func decodeToken() -> Token? {
        let accessToken = authTokenRepository.getToken(for: .accessTokenKey) ?? ""
        let token = JWTDecoder.decodeJWT(accessToken)
        return token
    }
}
