//
//  CreateUserRequestDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

struct CreateUserRequestDTO: Encodable {
    var email: String
    var firstName: String
    var lastName: String
    var status: String
}
