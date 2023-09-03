//
//  LockSecretInfoDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 29.08.2023.
//

import Foundation

struct CreateLockSecretInfoDTO: Encodable {
    var urlConnection: String
    var doorLockId: Int
}
