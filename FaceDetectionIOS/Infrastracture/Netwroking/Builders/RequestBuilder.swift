//
//  RequestBuilder.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

class RequestBuilder {
    static func buildRequest(_ requestModel: RequestModel) -> URLRequest? {
        let url = createUrl(requestModel)
    
        var urlRequest = URLRequest(url: url, timeoutInterval: 60.0)
        
        if let headers = requestModel.headers {
            addHeaders(&urlRequest, headers: headers)
        }
        
        if let body = requestModel.body {
            addBody(&urlRequest, body: body)
        }
        
        urlRequest.httpMethod = requestModel.httpMethod.rawValue        
        return urlRequest
    }
    
    static  private func createUrl(_ requestModel: RequestModel) -> URL {
        var url = URL(string: requestModel.basePath + requestModel.path)!
        
        if let queryParameters = requestModel.queryParameters {
            self.addQueryParameters(for: &url, queryParameters)
        }
        
        return url
    }
    
    static private func addQueryParameters(for url: inout URL, _ queryParameters: [String : String]) {
        var queryItems = [URLQueryItem]()
        queryParameters.forEach { item in
            queryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        url.append(queryItems: queryItems)
    }
    
    static private func addHeaders(_ urlRequest: inout URLRequest, headers: [String : String]) {
        headers.forEach { header in
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }
    }
    
    static private func addBody(_ urlRequest: inout URLRequest, body: [String: Any]) {
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        urlRequest.httpBody = jsonData
    }
}
