//
//  CreateSecretInfoDoorLockCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 29.08.2023.
//

import Foundation

protocol CreateSecretInfoDoorLockCommandProtocol {
    func execute(_ dto: LockSecretInfoDTO, _ completion: @escaping (Result<Void, Error>) -> Void) 
}
