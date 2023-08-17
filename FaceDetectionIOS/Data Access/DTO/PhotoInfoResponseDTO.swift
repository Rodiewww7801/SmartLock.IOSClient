//
//  PhotoInfoResponsetDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import Foundation

struct PhotoInfoResponseDTO: Decodable {
    var id: Int
    var imageMimeType: String
    var userId: String
}
