//
//  NetworkingServiceFactory.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

struct NetworkingFactory: NetworkingFactoryProtocol {
    private static var urlSessionShared: URLSession?
    private static var networkingServiceShared: NetworkingServiceProtocol?
    private static var tokenManagerShared: TokenManagerProtocol?
    
    static func urlSession() -> URLSession {
        if let urlSession = self.urlSessionShared {
            return urlSession
        }
        let urlSession = URLSession(configuration: .default)
        self.urlSessionShared = urlSession
        return urlSession
    }
    
    static func networkingService() -> NetworkingServiceProtocol {
        if let networkingService = self.networkingServiceShared {
            return networkingService
        }
        let networkingService = NetworkingService(urlSession: urlSession())
        self.networkingServiceShared = networkingService
        return networkingService
    }
    
    static func tokenManager() -> TokenManagerProtocol {
        if let tokenManagerShared = self.tokenManagerShared {
            return tokenManagerShared
        }
        let tokenManager = TokenManager(urlSession: urlSession())
        self.tokenManagerShared = tokenManager
        return tokenManager
    }
    
    static func networkingPublisher() -> NetworkingPublisher {
        return networkingService() as! NetworkingPublisher
    }
}
