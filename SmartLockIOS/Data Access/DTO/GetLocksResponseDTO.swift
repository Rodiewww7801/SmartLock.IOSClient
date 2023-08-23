//
//  GetLocksResponseDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

struct GetLocksResponseDTO: Decodable {
    var doorLocks: [LockDTO]
}
