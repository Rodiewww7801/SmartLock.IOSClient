//
//  UserCardModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 03.09.2023.
//

import Foundation
import UIKit

struct UserCardModel {
    var id: String
    var face: UIImage?
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var role: User.Role
    var predictionDistance: Float
}
