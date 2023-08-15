//
//  LoginResponseDTO.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

struct LoginResponseDTO: Decodable {
    var accessToken: String
    var refreshToken: String
}
