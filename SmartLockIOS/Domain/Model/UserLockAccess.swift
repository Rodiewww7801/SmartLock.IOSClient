//
//  UserLockAccess.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 21.08.2023.
//

import Foundation

struct UserLockAccess {
    var id: String
    var user: User
    var lock: Lock
    var hasAccess: Bool
}
