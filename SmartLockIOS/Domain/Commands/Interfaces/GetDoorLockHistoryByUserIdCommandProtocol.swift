//
//  GetDoorLockHistoryByUserIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

protocol GetDoorLockHistoryByUserIdCommandProtocol {
    func execute(userId: String, _ completion: @escaping (Result<GetLockHistoryDTO, Error>) -> Void)
}
