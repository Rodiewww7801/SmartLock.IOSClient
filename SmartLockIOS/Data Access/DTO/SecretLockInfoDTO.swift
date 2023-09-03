//
//  SecretLockInfoDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

struct SecretLockInfoDTO: Decodable {
    var id: Int
    var doorLockId: Int
    var urlConnection: String
    var secretKey: String
}
