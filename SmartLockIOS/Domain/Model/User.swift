//
//  User.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

struct User {
    enum Role: String {
        case admin = "Admin"
        case user = "User"
    }
    var id: String
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var role: Role
}
