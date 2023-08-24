//
//  GetLockHistoryDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

struct GetLockHistoryDTO: Decodable {
    var doorLockHistories: [LockHistoryDTO]
}
