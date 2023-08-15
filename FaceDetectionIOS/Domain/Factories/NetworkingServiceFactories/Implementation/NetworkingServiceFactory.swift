//
//  NetworkingServiceFactory.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

struct NetworkingServiceFactory: NetworkingServiceFactoryProtocol {
    private static var networkingServiceShared: NetworkingServiceProotocol?
    
    static func sessionManager() -> SessionManagerProtocol {
        return SessionManager()
    }
    
    static func networkingService() -> NetworkingServiceProotocol {
        if let networkingService = self.networkingServiceShared {
            return networkingService
        }
        let networkingService = NetworkingService(sessionManager: sessionManager())
        self.networkingServiceShared = networkingService
        return networkingService
    }
}
