//
//  SessionManager.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

protocol SessionManagerProtocol {
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Data?,NetworkingError>) -> ())
}

class SessionManager: SessionManagerProtocol {
    private var session: URLSession
    
    static var shared = SessionManager()
    var requestBuilder: RequestBuilder = RequestBuilder()

    init() {
        session = URLSession(configuration: .default)
    }
    
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<Data?,NetworkingError>) -> ()) {
        guard let request = RequestBuilder.buildRequest(requestModel) else { return }
        session.dataTask(with: request) { [weak self] data, urlResponse, error in
            guard let self = self else { return }
            let responseStatus = self.handleResponseStatusCode(urlResponse)
            switch responseStatus {
            case .success:
                if let data = data, let bodyString = String(data: data, encoding: .utf8)  {
                    print("[SessionManager]: SUCCESS response \(String(describing: urlResponse)), body \(bodyString)")
                } else {
                    print("[SessionManager]: SUCCESS response \(String(describing: urlResponse))")
                }
                
                completion(.success(data))
            case .failed(let networkingError):
                if let data = data, let bodyString = String(data: data, encoding: .utf8), bodyString.isEmpty == false  {
                    print("[SessionManager]: FAILURE response \(String(describing: urlResponse)), body \(bodyString)")
                    completion(.failure(NetworkingError.failed(message: bodyString)))
                } else {
                    print("[SessionManager]: FAILURE response \(String(describing: urlResponse))")
                    completion(.failure(networkingError))
                }
            }
        }.resume()
        
        print("[SessionManager]: request \(request)")
    }
    
    private func handleResponseStatusCode(_ urlResponse: URLResponse?) -> ResponseStatus {
        guard let httpResponse = urlResponse as? HTTPURLResponse else { return  .failed(.failed(message: "Unknown"))}
        switch httpResponse.statusCode {
        case 200...299:
            return .success
        case 401...403:
            return .failed(.authenticationError(message: "\(httpResponse.statusCode)"))
        case 501...599:
            return .failed(.badRequest(message: "\(httpResponse.statusCode)"))
        case 600:
            return .failed(.outdated(message: "\(httpResponse.statusCode)"))
        default:
            return .failed(.failed(message: "\(httpResponse.statusCode)"))
        }
    }
}
