//
//  CreateLockRequestDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

struct CreateLockRequestDTO: Encodable {
    var name: String
    var description: String
}
