//
//  NetworkingService.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation
import UIKit

protocol NetworkingServiceProotocol {
    typealias requsetCompletion = (Data?, URLResponse?, Error?) -> Void
    func request<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>)->())
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Void,Error>) -> ())
}

class NetworkingService: NetworkingServiceProotocol {    
    private var sessionManager: SessionManagerProtocol
    private let tokenManager: TokenManagerProtocol
    
    private var deviceId: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
    
    init(sessionManager: SessionManagerProtocol, tokenManager: TokenManagerProtocol) {
        self.sessionManager = sessionManager
        self.tokenManager = tokenManager
    }
    
    public func request<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>)->()) {
        if !requestModel.path.contains("Authentication") {
            tokenManager.refreshTokenIfNeeded {
                requestModel.headers = self.makeHttpHeaders(from: requestModel.headers)
                self.sessionManager.request(requestModel, completion)
            }
        } else {
            requestModel.headers = self.makeHttpHeaders(from: requestModel.headers)
            self.sessionManager.request(requestModel, completion)
        }
    }
    
    public func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Void,Error>)->()) {
        if !requestModel.path.contains("Authentication") {
            tokenManager.refreshTokenIfNeeded {
                requestModel.headers = self.makeHttpHeaders(from: requestModel.headers)
                self.sessionManager.request(requestModel, completion)
            }
        } else {
            requestModel.headers = self.makeHttpHeaders(from: requestModel.headers)
            self.sessionManager.request(requestModel, completion)
        }
    }
    
    private func makeHttpHeaders(from headers: [String:String]?) -> [String:String] {
        var newHeaders = headers ?? [String:String]()
        newHeaders.updateValue("application/json; charset=utf-8", forKey: "Content-Type")
        newHeaders.updateValue(deviceId, forKey: "device")
        newHeaders.updateValue("unknown", forKey: "country")
        newHeaders.updateValue("unknown", forKey: "city")
        addAuthenticationHeader(from: &newHeaders)
        return newHeaders
    }
    
    private func addAuthenticationHeader(from headers: inout [String:String]) {
        if let accessToken = tokenManager.accessToken {
            headers.updateValue("Bearer \(accessToken)", forKey: "Authorization")
        }
    }
}
