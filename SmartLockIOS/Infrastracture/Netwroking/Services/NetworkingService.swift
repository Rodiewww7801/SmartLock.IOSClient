//
//  NetworkingService.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation
import UIKit

protocol NetworkingPublisher {
    func subscribeListener(_ object: NetworkingListener)
    func removeListener(_ object: NetworkingListener)
}

protocol NetworkingListener: AnyObject {
    func receivedError(_ error: NetworkingError)
}

protocol NetworkingServiceProtocol {
    func authRequest<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>) -> Void)
    func authRequest(_ requestModel: RequestModel, _ completion: @escaping (Result<Data?,Error>) -> Void)
    func request<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>) -> Void)
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Data?,Error>) -> Void)
}

class NetworkingService: NetworkingServiceProtocol {
    private var urlSession: URLSession
    private var authenticatedSession: AuthenticatedHTTPClient
    
    private var listeners: [NetworkingListener] = [] // todo: need weak reference
    
    private var deviceId: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
        self.authenticatedSession = AuthenticatedHTTPClient(client: urlSession, tokenManager: NetworkingFactory.tokenManager())
    }
    
    func authRequest<Success>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success, Error>) -> Void) where Success : Decodable {
        makeRequest(with: authenticatedSession, requestModel, completion)
    }
    
    func authRequest(_ requestModel: RequestModel, _ completion: @escaping (Result<Data?, Error>) -> Void) {
        makeRequest(with: authenticatedSession, requestModel, completion)
    }
    
    func request<Success>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success, Error>) -> Void) where Success : Decodable {
        makeRequest(with: urlSession, requestModel, completion)
    }
    
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Data?, Error>) -> Void) {
        makeRequest(with: urlSession, requestModel, completion)
    }
    
    private func makeRequest<Success: Decodable>(with urlSession: HTTPClient, _ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>) -> Void) {
        self.makeHttpHeaders(from: &requestModel.headers)
        urlSession.request(requestModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let data = response.data, let decodedData = try? JSONDecoder().decode(Success.self, from: data) {
                    completion(.success(decodedData))
                } else if let data = response.data, let decodedData =  String(data: data, encoding: .utf8) {
                    notifyWithReceivedError(NetworkingError.responseError(response.urlResponse, message: decodedData))
                    completion(.failure(NetworkingError.responseError(response.urlResponse, message: decodedData)))
                } else {
                    notifyWithReceivedError(NetworkingError.responseError(response.urlResponse))
                    completion(.failure(NetworkingError.responseError(response.urlResponse)))
                }
            case .failure(let error):
                if let networkingError = error as? NetworkingError {
                    notifyWithReceivedError(networkingError)
                }
                completion(.failure(error))
            }
        }
    }
    
    private func makeRequest(with urlSession: HTTPClient,  _ requestModel: RequestModel, _ completion: @escaping (Result<Data?,Error>) -> Void) {
        self.makeHttpHeaders(from: &requestModel.headers)
        urlSession.request(requestModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                if let networkingError = error as? NetworkingError {
                    notifyWithReceivedError(networkingError)
                }
                completion(.failure(error))
            }
        }
    }
    
    private func makeHttpHeaders(from headers: inout [String:String]?) {
        if headers == nil {
            headers =  [String:String]()
        }
        if headers?["Content-Type"] == nil {
            headers?.updateValue("application/json; charset=utf-8", forKey: "Content-Type")
        }
        headers?.updateValue(deviceId, forKey: "device")
        headers?.updateValue("unknown", forKey: "country")
        headers?.updateValue("unknown", forKey: "city")
    }
}

extension NetworkingService: NetworkingPublisher {
    func subscribeListener(_ object: NetworkingListener) {
        if !listeners.contains(where: { $0 === object }) {
            listeners.append(object)
        }
    }
    
    func removeListener(_ object: NetworkingListener) {
        listeners.removeAll(where: { $0 === object })
    }
    
    private func notifyWithReceivedError(_ error: NetworkingError) {
        if case let NetworkingError.responseError(response, message: message) = error {
            if response.statusCode == 401 {
                listeners.forEach({ $0.receivedError(NetworkingError.authenticationError(message: message)) })
            } else {
                listeners.forEach({ $0.receivedError(error) })
            }
        } else {
            listeners.forEach({ $0.receivedError(error) })
        }
    }
}
