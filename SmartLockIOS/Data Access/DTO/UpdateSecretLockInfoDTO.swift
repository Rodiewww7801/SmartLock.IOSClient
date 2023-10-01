//
//  UpdateSecretLockInfoDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 02.09.2023.
//

import Foundation

struct UpdateSecretLockInfoDTO: Encodable {
    var id: Int
    var serialNumber: String
}
