//
//  UserDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

struct UserDTO: Decodable {
    var id: String
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var status: String
}
