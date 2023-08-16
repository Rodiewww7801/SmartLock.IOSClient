//
//  RequestStatus.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

enum NetworkingStatus<T> {
    case success(T?)
    case failure(NetworkingError)
}

enum ResponseStatusCode {
    case success
    case failed(NetworkingError)
}

enum NetworkingError: Error {
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case withError(errorString: String)
    case refreshTokenExpired
}
