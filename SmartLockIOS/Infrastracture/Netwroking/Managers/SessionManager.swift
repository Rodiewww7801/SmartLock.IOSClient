//
//  SessionManager.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

protocol HTTPClient {
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<(data: Data?, urlResponse: HTTPURLResponse),Error>) -> ())
}

extension URLSession: HTTPClient {
    struct InvalidHTTPResponseError: Error { }
    
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<(data: Data?, urlResponse: HTTPURLResponse), Error>) -> ()) {
        let request = RequestBuilder.buildRequest(requestModel)
        self.dataTask(with: request) { data, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse else {
                print("[HTTPClient]: FAILURE response \(String(describing: urlResponse))")
                return completion(.failure(InvalidHTTPResponseError()))
            }
            if let data = data, let bodyString = String(data: data, encoding: .utf8)  {
                print("[HTTPClient]: SUCCESS response \(String(describing: urlResponse)), body: \(bodyString)")
            } else {
                print("[HTTPClient]: SUCCESS response \(String(describing: urlResponse))")
            }
            return completion(.success((data, response)))
        }.resume()
        
        print("[HTTPClient]: request \(request)")
    }
}

class AuthenticatedHTTPClient: HTTPClient {
    struct InvalidHTTPResponseError: Error { }
    
    let client: HTTPClient
    var tokenManager: TokenManagerProtocol
    
    init(client: HTTPClient, tokenManager: TokenManagerProtocol) {
        self.client = client
        self.tokenManager = tokenManager
    }
    
    func request(_ requestModel: RequestModel, _ completion: @escaping (Result<(data: Data?, urlResponse: HTTPURLResponse), Error>) -> ()) {
        tokenManager.refreshTokenIfNeeded { [weak self] result in
            guard let self = self else { return }
            self.addAuthenticationHeader(from: &requestModel.headers)
            switch result {
            case .success():
                self.client.request(requestModel, completion)
            case .failure(let error):
                print("[AuthenticatedHTTPClient]: FAILURE send request \(RequestBuilder.buildRequest(requestModel))")
                completion(.failure(error))
            }
        }
    }
    
    private func addAuthenticationHeader(from headers: inout [String:String]?) {
        if let accessToken = tokenManager.accessToken {
            headers?.updateValue("Bearer \(accessToken)", forKey: "Authorization")
        }
    }
}
