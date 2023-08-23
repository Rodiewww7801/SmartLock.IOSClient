//
//  UpdatePlaceDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

struct UpdatePlaceDTO: Encodable {
    var id: Int
    var name: String
    var description: String
}
