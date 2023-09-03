//
//  UpdateSecretInfoLockCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

protocol UpdateSecretInfoLockCommandProtocol {
    func execute(lockId: String, _ dto: UpdateSecretLockInfoDTO, _ completion: @escaping (Result<Void, Error>) -> Void)
}
