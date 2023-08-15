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

enum NetworkingError: String, Error {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}
