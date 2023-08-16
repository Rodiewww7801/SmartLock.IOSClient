//
//  RepositoryFactory.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

class RepositoryFactory: RepositoryFactoryProtocol {
    static func authTokenRepository() -> AuthTokenRepositoryProtocol {
        return AuthTokenRepository()
    }
    
    static func userRepository() -> UserRepositoryProtocol {
        return UserRepository()
    }
}
