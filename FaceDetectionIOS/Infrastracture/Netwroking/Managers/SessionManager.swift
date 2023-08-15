//
//  SessionManager.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

protocol SessionManagerProtocol {
    func request<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>) -> ())
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Void,Error>) -> ())
}

class SessionManager: SessionManagerProtocol {
    private var session: URLSession
    
    static var shared = SessionManager()
    var requestBuilder: RequestBuilder = RequestBuilder()

    init() {
        session = URLSession(configuration: .default)
    }
    
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Void,Error>) -> ()) {
        guard let request = RequestBuilder.buildRequest(requestModel) else { return }
        session.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let self = self else { return }
            let responseStatus = self.handleResponseStatusCode(urlResponse)
            switch responseStatus {
            case .success:
                completion(.success( () ))
                if let data = data, let bodyString = String(data: data, encoding: .utf8)  {
                    print("[SessionManager]: SUCCESS response \(String(describing: urlResponse)), body \(bodyString)")
                } else {
                    print("[SessionManager]: SUCCESS response \(String(describing: urlResponse))")
                }
            case .failed(let networkingError):
                if let data = data, let bodyString = String(data: data, encoding: .utf8)  {
                    completion(.failure(NetworkingError.withError(errorString: bodyString)))
                    print("[SessionManager]: FAILURE response \(String(describing: urlResponse)), body \(bodyString)")
                } else {
                    completion(.failure(networkingError))
                    print("[SessionManager]: FAILURE response \(String(describing: urlResponse))")
                }
            }
        }.resume()
        
        print("[SessionManager]: request \(request)")
    }
    
    func request<Success: Decodable>(_ requestModel: RequestModel, _ completion: @escaping (Result<Success,Error>) -> ()) {
        guard let request = RequestBuilder.buildRequest(requestModel) else { return }
        session.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let self = self else { return }
            let responseStatus = self.handleResponseStatusCode(urlResponse)
            switch responseStatus {
            case .success:
                if let data = data, let model = try? JSONDecoder().decode(Success.self, from: data) {
                    completion(.success(model))
                } else {
                    completion(.failure(NetworkingError.unableToDecode))
                }
                if let data = data, let bodyString = String(data: data, encoding: .utf8)  {
                    print("[SessionManager]: SUCCESS response \(String(describing: urlResponse)), body \(bodyString)")
                } else {
                    print("[SessionManager]: SUCCESS response \(String(describing: urlResponse))")
                }
               
            case .failed(let networkingError):
                if let data = data, let bodyString = String(data: data, encoding: .utf8)  {
                    completion(.failure(NetworkingError.withError(errorString: bodyString)))
                    print("[SessionManager]: FAILURE response \(String(describing: urlResponse)), body \(bodyString)")
                } else {
                    completion(.failure(networkingError))
                    print("[SessionManager]: FAILURE response \(String(describing: urlResponse))")
                }
            }
        }.resume()
        
        print("[SessionManager]: request \(request)")
    }
    
    private func handleResponseStatusCode(_ urlResponse: URLResponse?) -> ResponseStatusCode {
        guard let httpResponse = urlResponse as? HTTPURLResponse else { return  .failed(.failed)}
        switch httpResponse.statusCode {
        case 200...299:
            return .success
        case 401...403:
            return .failed(.authenticationError)
        case 501...599:
            return .failed(.badRequest)
        case 600:
            return .failed(.outdated)
        default:
            return .failed(.failed)
        }
    }
}
