//
//  UpdateAccessLockDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

struct UpdateAccessLockDTO: Encodable {
    var userId: String
    var doorLockId: String
    var hasAccess: Bool
}

