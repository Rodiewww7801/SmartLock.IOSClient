//
//  AuthTokenRepository.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

class AuthTokenRepository: AuthTokenRepositoryProtocol {
    private let securedStorage: SecureStorageProtocol
    
    init() {
        self.securedStorage = KeychainStorage(secureStorageQueryable: GenericPasswordQueryable(service: "AuthenticationTokenService"))
    }
    
    func getToken(for key: KeychainStorageKeys) -> String? {
        do {
            let token = try securedStorage.getValue(for: key.rawValue)
            return token
        } catch {
            print("[AuthTokenRepository]: \(error)")
        }
        return nil
    }
    
    func setToken(_ value: String, for key: KeychainStorageKeys) {
        do {
            try securedStorage.setValue(value, for: key.rawValue)
        } catch {
            print("[AuthTokenRepository]: \(error)")
        }
    }
    
    func removeToken(for key: KeychainStorageKeys) {
        do {
            try securedStorage.removeValue(for: key.rawValue)
        } catch {
            print("[AuthTokenRepository]: \(error)")
        }
    }
}
