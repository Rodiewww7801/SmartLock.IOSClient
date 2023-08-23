//
//  LockRepositoryProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

protocol LockRepositoryProtocol {
    func getLocks() async -> [Lock]
    func getLock(lockId: String) async -> Lock?
    func getUserLockAccesses(lockId: String) async -> [UserLockAccess] 
}
