//
//  UserLockAccessDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

struct UserLockAccessDTO: Decodable {
    var id: Int
    var userId: String
    var doorLockId: Int
    var hasAccess: Bool
}
