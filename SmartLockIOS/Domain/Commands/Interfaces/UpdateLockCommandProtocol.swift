//
//  UpdateDoorLockCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

protocol UpdateLockCommandProtocol {
    func execute(lockId: Int, _ dto: UpdateLockDTO, _ completion: @escaping (Result<Void, Error>) -> Void)
}
