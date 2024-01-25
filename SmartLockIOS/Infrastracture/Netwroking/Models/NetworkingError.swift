//
//  NetworkingError.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

enum NetworkingError: Error {
    case authenticationError(message: String? = nil)
    case refreshTokenExpired(message: String? = nil)
    case failed(message: String? = nil)
    case unableToDecode(message: String? = nil)
    case responseError(HTTPURLResponse, message: String? = nil)
    
    var title: String {
        switch self {
        case .authenticationError(_):
            return "Authentication error"
        case .failed(_):
            return "Failed"
        case .unableToDecode(_):
            return "Unable to decode"
        case .refreshTokenExpired(_):
            return "Refresh token expired"
        case .responseError(let response, _):
            return "Response error \(response.statusCode)"
        }
    }
    
    var message: String? {
        switch self {
        case .authenticationError(let message):
            return message
        case .failed(let message):
            return message
        case .unableToDecode(let message):
            return message
        case .refreshTokenExpired(let message):
            return message
        case .responseError(let response, let message):
            if message?.isEmpty == false {
                return message
            } else {
                return response.description
            }
        }
    }
}
