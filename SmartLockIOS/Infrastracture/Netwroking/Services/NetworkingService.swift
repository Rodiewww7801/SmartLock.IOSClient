//
//  NetworkingService.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation
import UIKit

protocol NetworkingPublisher {
    func subscribeListener(_ object: NetwrokingListener)
    func removeListener(_ object: NetwrokingListener)
}

protocol NetwrokingListener: AnyObject {
    func receivedError(_ error: NetworkingError)
}

protocol NetworkingServiceProotocol {
    func request<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>)->())
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Void,Error>) -> ())
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Data,Error>) -> ())
}

class NetworkingService: NetworkingServiceProotocol {    
    private var sessionManager: SessionManagerProtocol
    
    private var listeners: [NetwrokingListener] = [] // todo: need weak reference
    
    private var tokenManager: TokenManagerProtocol {
        return NetworkingFactory.tokenManager()
    }
    
    private var deviceId: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
    
    init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
    
    public func request<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>)->()) {
        checkToken(requestModel: requestModel) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                requestModel.headers = self.makeHttpHeaders(from: requestModel.headers)
                self.sessionManager.request(requestModel) { [weak self] result in
                    switch result {
                    case .success(let data):
                        if let data = data, let decodedData = try? JSONDecoder().decode(Success.self, from: data) {
                            completion(.success(decodedData))
                        } else {
                            self?.notifyWithReceivedError(NetworkingError.unableToDecode())
                            completion(.failure(NetworkingError.unableToDecode()))
                        }
                    case .failure(let error):
                        self?.notifyWithReceivedError(error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    public func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Void,Error>)->()) {
        checkToken(requestModel: requestModel) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                requestModel.headers = self.makeHttpHeaders(from: requestModel.headers)
                self.sessionManager.request(requestModel) { [weak self] result in
                    switch result {
                    case .success(_):
                        completion(.success( () ))
                    case .failure(let error):
                        self?.notifyWithReceivedError(error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    public func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Data,Error>)->()) {
        checkToken(requestModel: requestModel) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                requestModel.headers = self.makeHttpHeaders(from: requestModel.headers)
                self.sessionManager.request(requestModel) { [weak self] result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            completion(.success(data))
                        } else {
                            self?.notifyWithReceivedError(NetworkingError.noData())
                            completion(.failure(NetworkingError.noData()))
                        }
                    case .failure(let error):
                        self?.notifyWithReceivedError(error)
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func checkToken(requestModel: RequestModel, _ completion: @escaping (NetworkingError?)->Void) {
        if !requestModel.path.contains("Authentication") || requestModel.path.contains("logout") {
            tokenManager.refreshTokenIfNeeded { result in
                switch result {
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    private func makeHttpHeaders(from headers: [String:String]?) -> [String:String] {
        var newHeaders = headers ?? [String:String]()
        if headers?["Content-Type"] == nil {
            newHeaders.updateValue("application/json; charset=utf-8", forKey: "Content-Type")
        }
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

extension NetworkingService: NetworkingPublisher {
    func subscribeListener(_ object: NetwrokingListener) {
        if !listeners.contains(where: { $0 === object }) {
            listeners.append(object)
        }
    }
    
    func removeListener(_ object: NetwrokingListener) {
        listeners.removeAll(where: { $0 === object })
    }
    
    private func notifyWithReceivedError(_ error: NetworkingError) {
        listeners.forEach({ $0.receivedError(error) })
    }
}
