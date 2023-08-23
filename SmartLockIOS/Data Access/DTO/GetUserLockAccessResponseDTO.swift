//
//  GetUserLockAccessResponseDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

struct GetUserLockAccessResponseDTO: Decodable {
    var accessesDoorLock: [UserLockAccessDTO]
}
