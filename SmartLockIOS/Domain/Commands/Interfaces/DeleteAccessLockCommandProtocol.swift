//
//  DeleteAccessLockCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

protocol DeleteAccessLockCommandProtocol {
    func execute(lockId: String, userId: String, _ completion: @escaping (Result<Void, Error>) -> Void)
}
