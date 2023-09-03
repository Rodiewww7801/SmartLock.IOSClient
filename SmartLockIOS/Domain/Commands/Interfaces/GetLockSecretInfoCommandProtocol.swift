//
//  GetLockSecretInfoCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

protocol GetLockSecretInfoCommandProtocol {
    func execute(lockId: String, _ completion: @escaping (Result<SecretLockInfoDTO, Error>) -> Void)
}
