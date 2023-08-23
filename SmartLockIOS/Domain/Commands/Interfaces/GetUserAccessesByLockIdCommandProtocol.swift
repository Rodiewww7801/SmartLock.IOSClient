//
//  GetUserAccessesByLockIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

protocol GetUserAccessesByLockIdCommandProtocol {
    func execute(lockId: String, _ completion: @escaping (Result<GetUserLockAccessResponseDTO, Error>) -> Void)
}
