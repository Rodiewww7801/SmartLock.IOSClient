//
//  RecognizeUserDTO.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 27.08.2023.
//

import Foundation

struct RecognizeUserDTO: Decodable {
    var id: String
    var username: String
    var email: String
    var firstName: String
    var lastName: String
    var status: String
    var predictionDistance: Float
    var base64UserImage: Base64ImageDTO
    
    struct Base64ImageDTO: Decodable {
        var data: String
        var imageMimeType: String
    }
}
