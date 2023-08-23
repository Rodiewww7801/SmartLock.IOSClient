//
//  User.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation
import UIKit

struct User {
    var id: String
    var face: UIImage?
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var role: Role
}

extension User {
    enum Role: String {
        case admin = "Admin"
        case user = "User"
    }
}
