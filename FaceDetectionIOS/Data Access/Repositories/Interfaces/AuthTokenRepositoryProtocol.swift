//
//  AuthTokenRepositoryProtocol.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

protocol AuthTokenRepositoryProtocol {
    func getToken(for key: KeychainStorageKeys) -> String?
    func setToken(_ value: String, for key: KeychainStorageKeys)
    func removeToken(for key: KeychainStorageKeys)
}
