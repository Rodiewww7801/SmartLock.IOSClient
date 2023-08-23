//
//  GetLockByIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

protocol GetLockByIdCommandProtocol {
    func execute(lockId: String, _ completion: @escaping (Result<LockDTO, Error>) -> Void)
}
