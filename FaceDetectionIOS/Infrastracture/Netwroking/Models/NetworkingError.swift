//
//  NetworkingError.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

enum NetworkingError: Error {
    case authenticationError(message: String? = nil)
    case badRequest(message: String? = nil)
    case outdated(message: String? = nil)
    case failed(message: String? = nil)
    case noData(message: String? = nil)
    case unableToDecode(message: String? = nil)
    case refreshTokenExpired(message: String? = nil)
    case failedToCreateRequestModel(message: String? = nil)
    
    var title: String {
        switch self {
        case .authenticationError(_):
            return "Authentication error"
        case .badRequest(_):
            return "Bad request"
        case .outdated(_):
            return "Outdated"
        case .failed(_):
            return "Failed"
        case .noData(_):
            return "No data"
        case .unableToDecode(_):
            return "Unable to decode"
        case .refreshTokenExpired(_):
            return "Refresh token expired"
        case .failedToCreateRequestModel(_):
            return "Failed to create request model"
        }
    }
    
    var message: String? {
        switch self {
        case .authenticationError(let message):
            return message
        case .badRequest(let message):
            return message
        case .outdated(let message):
            return message
        case .failed(let message):
            return message
        case .noData(let message):
            return message
        case .unableToDecode(let message):
            return message
        case .refreshTokenExpired(let message):
            return message
        case .failedToCreateRequestModel(let message):
            return message
        }
    }
}
