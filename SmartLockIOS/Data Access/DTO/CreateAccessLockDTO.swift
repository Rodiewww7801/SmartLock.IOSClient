//
//  CreateAccessLockDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

struct CreateAccessLockDTO: Encodable {
    var userId: String
    var doorLockId: Int
    var hasAccess: Bool
}
