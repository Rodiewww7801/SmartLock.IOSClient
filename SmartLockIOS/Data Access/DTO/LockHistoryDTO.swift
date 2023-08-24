//
//  LockHistoryDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

struct LockHistoryDTO: Decodable {
    var id: Int
    var userId: String
    var doorLockId: Int
    var openedDateTime: String
}
