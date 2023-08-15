//
//  RegisterModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

struct RegisterRequestDTO: Codable {
    let email: String
    let password: String
    let confirmPassword: String
    let firstName: String
    let lastName: String
}
