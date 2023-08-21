//
//  Token.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

struct Token: Decodable {
    var nameId: String
    var givenName: String
    var familyName: String
    var role: String
    var notValidBefore: TimeInterval
    var expirationTime: TimeInterval
    var issuedAtTime: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case nameId = "nameid"
        case givenName = "given_name"
        case familyName = "family_name"
        case role = "role"
        case notValidBefore = "nbf"
        case expirationTime = "exp"
        case issuedAtTime = "iat"
    }
}
