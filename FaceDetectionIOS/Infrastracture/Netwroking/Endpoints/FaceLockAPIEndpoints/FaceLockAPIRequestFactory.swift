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
    
    // MARK: - AdminUser
    
    static func createAdminCreateUserRequest(with dto: CreateUserRequestDTO) -> RequestModel? {
        let encodedData = try? dto.jsonEncoder()
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.adminCreateUser, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func createAdminGetUsersRequest() -> RequestModel {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.adminGetUsers, httpMethod: .get)
        return model
    }
    
    static func createAdminGetUserRequest(userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.adminGetUser.replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func createAdminGetUserPhotosInfo(userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.adminGetUserPhotosInfo.replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func createAdminGetUserPhoto(userId: String, photoId: String) -> RequestModel {
        let path = FaceLockAPIPaths.adminGetUserPhoto
            .replacingOccurrences(of: "{userId}", with: userId)
            .replacingOccurrences(of: "{faceId}", with: photoId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    // MARK: - Authentication
    
    static func createRegisterRequest(with dto: RegisterRequestDTO) -> RequestModel? {
        let encodedData = try? dto.jsonEncoder()
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.register, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func createLoginRequest(with dto: LoginRequestDTO) -> RequestModel? {
        let encodedData = try? dto.jsonEncoder()
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.login, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func createRefreshRequest(refreshToken: String) -> RequestModel? {
        let headers = ["refreshToken":refreshToken]
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.refresh, httpMethod: .post, headers: headers)
        return model
    }
    
    static func createLogoutRequest(accessToken: String, refreshToken: String) -> RequestModel? {
        let headers = ["refreshToken":refreshToken]
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.logout, httpMethod: .post, headers: headers)
        return model
    }
    
    // MARK: - User
    
    static func createGetUserInfoRequest() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserInfo, httpMethod: .get)
        return model
    }
    
    static func createGetUserVisitsRequest() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserVisits, httpMethod: .get)
        return model
    }
    
    static func createGetUserAccessesRequest() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserAccesses, httpMethod: .get)
        return model
    }
    
    static func createGetUserHistoriesRequest() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserHistories, httpMethod: .get)
        return model
    }
    
    static func createUpdateAccountRequest(with dto: UserDTO) -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.updateAccount, httpMethod: .post)
        return model
    }
    
    static func createDeleteAccountRequest() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.deleteAccount, httpMethod: .delete)
        return model
    }
}
