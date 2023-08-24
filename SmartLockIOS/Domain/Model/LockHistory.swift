//
//  LockHistrory.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 21.08.2023.
//

import Foundation

struct LockHistory {
    var id: String
    var user: User
    var lock: Lock
    var openedDataTime: Date
}
