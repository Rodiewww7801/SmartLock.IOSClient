//
//  TokenManager.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

protocol TokenObservable {
    func subscribeListener(_ object: TokenListener)
    func removeListener(_ object: TokenListener)
}

protocol TokenListener: AnyObject {
    func refreshTokenExpired()
}

protocol TokenManagerProtocol {
    var accessToken: String? { get }
    func refreshTokenIfNeeded(_ completion: ((Result<Void,Error>)->Void)?)
}

class TokenManager: TokenManagerProtocol {
    private var authTokenRepository: AuthTokenRepositoryProtocol
    private var sessionManager: SessionManagerProtocol
    
    private var listeners: [TokenListener] = []
    
    var accessToken: String? {
        return authTokenRepository.getToken(for: .accessTokenKey)
    }
    
    var refreshToken: String? {
        return authTokenRepository.getToken(for: .refreshTokenKey)
    }
    
    init(sessionManager: SessionManagerProtocol) {
        self.authTokenRepository = RepositoryFactory.authTokenRepository()
        self.sessionManager = NetworkingFactory.sessionManager()
    }
    
    func refreshTokenIfNeeded(_ completion: ((Result<Void,Error>)->Void)?) {
        let token = decodeToken()
        if let token = token, Date().timeIntervalSince1970 > token.expirationTime {
            print("[TokenManager] token has expired")
            if let refreshToken = refreshToken, let requestModel = FaceLockAPIRequestFactory.createRefreshRequest(refreshToken: refreshToken) {
                sessionManager.request(requestModel) { [weak self] (result: Result<RefreshResponseDTO, Error>) in
                    switch result {
                    case .success(let success):
                        print("[TokenManager] token has updated")
                        self?.authTokenRepository.setToken(success.accessToken, for: .accessTokenKey)
                        completion?(.success( () ))
                    case .failure(_):
                        print("[TokenManager] refresh token has expired")
                        self?.authTokenRepository.removeToken(for: .refreshTokenKey)
                        self?.authTokenRepository.removeToken(for: .accessTokenKey)
                        completion?(.failure(NetworkingError.refreshTokenExpired))
                        self?.notifyRefreshTokenExpired()
                    }
                }
            }
        } else {
            completion?(.success( () ))
        }
    }
    
    private func decodeToken() -> Token? {
        let accessToken = authTokenRepository.getToken(for: .accessTokenKey) ?? ""
        let token = JWTDecoder.decodeJWT(accessToken)
        return token
    }
}

extension TokenManager: TokenObservable {
    func subscribeListener(_ object: TokenListener) {
        if !listeners.contains(where: { $0 === object }) {
            listeners.append(object)
        }
    }
    
    func removeListener(_ object: TokenListener) {
        listeners.removeAll(where: { $0 === object })
    }
    
    private func notifyRefreshTokenExpired() {
        listeners.forEach({ $0.refreshTokenExpired() })
    }
}
