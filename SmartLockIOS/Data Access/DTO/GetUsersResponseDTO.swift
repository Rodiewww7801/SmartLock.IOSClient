//
//  GetUsersResponseDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

struct GetUsersResponseDTO: Decodable {
    var users: [UserDTO]
}
