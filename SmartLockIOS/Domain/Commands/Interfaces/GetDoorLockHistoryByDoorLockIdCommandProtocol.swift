//
//  GetDoorLockHistoryByDoorLockIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

protocol GetDoorLockHistoryByDoorLockIdCommandProtocol {
    func execute(lockId: String, _ completion: @escaping (Result<GetLockHistoryDTO, Error>) -> Void)
}
