//
//  NetworkingServiceFactoryProtocol.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

protocol NetworkingFactoryProtocol {
    static func urlSession() -> URLSession
    static func networkingService() -> NetworkingServiceProtocol
    static func tokenManager() -> TokenManagerProtocol
    static func networkingPublisher() -> NetworkingPublisher
}
