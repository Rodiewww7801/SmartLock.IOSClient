//
//  UpdateUserDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

struct UpdateUserDTO: Codable {
    var username: String
    var email: String
    var firstName: String
    var lastName: String
}
