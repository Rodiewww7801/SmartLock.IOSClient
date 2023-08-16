//
//  NetworkingServiceFactoryProtocol.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

protocol NetworkingFactoryProtocol {
    static func sessionManager() -> SessionManagerProtocol 
    static func networkingService() -> NetworkingServiceProotocol
    static func tokenManager() -> TokenManagerProtocol
    static func tokenObservable() -> TokenObservable
}
