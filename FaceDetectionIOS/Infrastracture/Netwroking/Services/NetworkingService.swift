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
    private let authTokenRepository: AuthTokenRepositoryProtocol
    
    private var deviceId: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
        self.authTokenRepository = RepositoryFactory.authTokenRepository()
    }
    
    public func request<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>)->()) {
        requestModel.headers = makeHttpHeaders(from: requestModel.headers)
        sessionManager.request(requestModel, completion)
    }
    
    public func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Void,Error>)->()) {
        requestModel.headers = makeHttpHeaders(from: requestModel.headers)
        sessionManager.request(requestModel, completion)
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
        if let accessToken = authTokenRepository.getToken(for: .accessTokenKey) {
            headers.updateValue("Bearer \(accessToken)", forKey: "Authorization")
        }
    }
}
