//
//  FaceLockAPIEndpoints.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation
import UIKit

class FaceLockAPIRequestFactory {
    static var serverAPI: String {
        ApplicationConfig.getConfigurationValue(for: ApplicationConfigKey.faceLockAPIUrl)
    }
    
    // MARK: - AdminUser
    
    static func createAdminCreateUserRequest(with dto: CreateUserRequestDTO) -> RequestModel? {
        let encodedData = try? JSONEncoder().encode(dto)
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
    
    static func createAdminAddUserPhotos(userId: String, images: [UIImage]) -> RequestModel {
        let path = FaceLockAPIPaths.adminAddUserPhotos.replacingOccurrences(of: "{userId}", with: userId)
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers = ["Content-Type" : "multipart/form-data; boundary=\(boundary)"]

        let body = NSMutableData()

        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                continue
            }

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"Files\"; filename=\"image\(index).jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        let requestModel = RequestModel(basePath: serverAPI, path: path, httpMethod: .post, headers: headers)
        requestModel.body = body as Data
        return requestModel
    }
    
    static func createAdminDeleteUserByPhotoId(userId: String, photoId: Int) -> RequestModel {
        let path = FaceLockAPIPaths.adminDeleteUserPhotoByPhotoId
            .replacingOccurrences(of: "{userId}", with: userId)
            .replacingOccurrences(of: "{faceId}", with: String(photoId))
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .delete)
        return model
    }
    
    static func createAdminDeleteUserAccount(userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.adminDeleteUser
            .replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .delete)
        return model
    }
    
    // MARK: - Authentication
    
    static func createRegisterRequest(with dto: RegisterRequestDTO) -> RequestModel? {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.register, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func createLoginRequest(with dto: LoginRequestDTO) -> RequestModel? {
        let encodedData = try? JSONEncoder().encode(dto)
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
