//
//  AdminUpdateUserDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

struct AdminUpdateUserDTO: Codable {
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var status: String
}
