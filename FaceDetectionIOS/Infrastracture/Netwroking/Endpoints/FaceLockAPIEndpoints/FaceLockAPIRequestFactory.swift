//
//  FaceLockAPIEndpoints.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

class FaceLockAPIRequestFactory {
    static var serverAPI: String {
        ApplicationConfig.getConfigurationValue(for: ApplicationConfigKey.faceLockAPIUrl)
    }
    
    // MARK: - Authentication Endpoints
    
    static func createRegisterRequest(_ model: RegisterRequestDTO) -> RequestModel? {
        let encodedData = try? model.jsonEncoder()
        let registerEndpoint = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.register, httpMethod: .post)
        registerEndpoint.body = encodedData
        return registerEndpoint
    }
    
    static func createLoginRequest(_ model: LoginRequestDTO) -> RequestModel? {
        let encodedData = try? model.jsonEncoder()
        let registerEndpoint = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.login, httpMethod: .post)
        registerEndpoint.body = encodedData
        return registerEndpoint
    }
}
