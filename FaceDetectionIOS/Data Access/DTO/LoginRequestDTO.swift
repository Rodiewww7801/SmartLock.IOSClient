//
//  LoginModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}
