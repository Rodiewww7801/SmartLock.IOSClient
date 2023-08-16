//
//  RepositoryFactoryProtocol.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

protocol RepositoryFactoryProtocol {
    static func authTokenRepository() -> AuthTokenRepositoryProtocol
    static func userRepository() -> UserRepositoryProtocol
}
