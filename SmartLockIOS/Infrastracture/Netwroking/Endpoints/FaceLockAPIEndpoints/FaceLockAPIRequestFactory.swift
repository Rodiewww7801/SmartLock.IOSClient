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
    
    static func adminCreateUserRequest(with dto: CreateUserRequestDTO) -> RequestModel? {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.adminCreateUser, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func adminGetUsersRequest() -> RequestModel {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.adminGetUsers, httpMethod: .get)
        return model
    }
    
    static func adminGetUserRequest(userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.adminGetUser.replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func adminGetUserPhotosInfo(userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.adminGetUserPhotosInfo.replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func adminGetUserPhoto(userId: String, photoId: String) -> RequestModel {
        let path = FaceLockAPIPaths.adminGetUserPhoto
            .replacingOccurrences(of: "{userId}", with: userId)
            .replacingOccurrences(of: "{faceId}", with: photoId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func adminAddUserPhotos(userId: String, images: [UIImage]) -> RequestModel {
        let path = FaceLockAPIPaths.adminAddUserPhotos.replacingOccurrences(of: "{userId}", with: userId)
        let boundary = UUID().uuidString
        let headers = ["Content-Type" : "multipart/form-data; boundary=\(boundary)"]
        let bodyData = convertImagesToBodyData(boundary: boundary, images)
        let requestModel = RequestModel(basePath: serverAPI, path: path, httpMethod: .post, headers: headers)
        requestModel.body = bodyData
        return requestModel
    }
    
    static func adminDeleteUserByPhotoId(userId: String, photoId: Int) -> RequestModel {
        let path = FaceLockAPIPaths.adminDeleteUserPhotoByPhotoId
            .replacingOccurrences(of: "{userId}", with: userId)
            .replacingOccurrences(of: "{faceId}", with: String(photoId))
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .delete)
        return model
    }
    
    static func adminDeleteUserAccount(userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.adminDeleteUser
            .replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .delete)
        return model
    }
    
    static func adminUpdateUser(userId: String, _ dto: AdminUpdateUserDTO) -> RequestModel {
        let encodedData = try? JSONEncoder().encode(dto)
        let path =  FaceLockAPIPaths.adminUpdateUser.replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .put)
        model.body = encodedData
        return model
    }
    
    // MARK: - Authentication
    
    static func register(with dto: RegisterRequestDTO) -> RequestModel? {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.register, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func login(with dto: LoginRequestDTO) -> RequestModel? {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.login, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func refresh(refreshToken: String) -> RequestModel? {
        let headers = ["refreshToken":refreshToken]
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.refresh, httpMethod: .post, headers: headers)
        return model
    }
    
    static func logout(accessToken: String, refreshToken: String) -> RequestModel? {
        let headers = ["refreshToken":refreshToken]
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.logout, httpMethod: .post, headers: headers)
        return model
    }
    
    // MARK: - User
    
    static func getUserInfo() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserInfo, httpMethod: .get)
        return model
    }
    
    static func getUserVisits() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserVisits, httpMethod: .get)
        return model
    }
    
    static func getUserAccesses() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserAccesses, httpMethod: .get)
        return model
    }
    
    static func getUserHistories() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserHistories, httpMethod: .get)
        return model
    }
    
    static func updateAccount(with dto: UserDTO) -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.updateAccount, httpMethod: .post)
        return model
    }
    
    static func deleteAccount() -> RequestModel? {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.deleteAccount, httpMethod: .delete)
        return model
    }
    
    static func updateUser(_ dto: UpdateUserDTO) -> RequestModel {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.updateAccount, httpMethod: .put)
        model.body = encodedData
        return model
    }
    
    static func deleteUser() -> RequestModel {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.deleteAccount, httpMethod: .delete)
        return model
    }
    
    static func getUserPhotosInfo() -> RequestModel {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getUserPhotosInfo, httpMethod: .get)
        return model
    }
    
    static func getUserPhotos(photoId: String) -> RequestModel {
        let path = FaceLockAPIPaths.getUserPhotos
            .replacingOccurrences(of: "{faceId}", with: photoId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    // MARK: - Recognition
    
    static func recognizeUser(images: [UIImage]) -> RequestModel {
        let boundary = "Boundary-\(UUID().uuidString)"
        let headers = ["Content-Type" : "multipart/form-data; boundary=\(boundary)"]
        let bodyData = convertImagesToBodyData(boundary: boundary, images)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.recognizeUser, httpMethod: .post, headers: headers)
        model.body = bodyData
        return model
    }
    
    static func recognizeUserForDoorLock(lockId: String, images: [UIImage]) -> RequestModel {
        let path = FaceLockAPIPaths.recognizeUserForDoorLock.replacingOccurrences(of: "{doorLockId}", with: lockId)
        let boundary = UUID().uuidString
        let headers = ["Content-Type" : "multipart/form-data; boundary=\(boundary)"]
        let bodyData = convertImagesToBodyData(boundary: boundary, images)
        let model = RequestModel(basePath: serverAPI, path: path , httpMethod: .post, headers: headers)
        model.body = bodyData
        return model
    }
    
    //MARK: - Lock
    
    static func createLock(_ dto: CreateLockRequestDTO) -> RequestModel {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.createLock, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func createAccessLock(_ dto: AccessLockDTO) -> RequestModel {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.createAccessLock, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func getLocks() -> RequestModel {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getLocks, httpMethod: .get)
        return model
    }
    
    static func getLockById(lockId: String) -> RequestModel {
        let path = FaceLockAPIPaths.getLockById.replacingOccurrences(of: "{doorLockId}", with: lockId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func getDoorLockSecretInfo(lockId: String) -> RequestModel {
        let path = FaceLockAPIPaths.getDoorLockSecretInfo.replacingOccurrences(of: "{doorLockId}", with: lockId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func getUserAccessesByLockId(lockId: String) -> RequestModel {
        let path = FaceLockAPIPaths.getUserAccessesByLockId.replacingOccurrences(of: "{doorLockId}", with: lockId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func getUserAccessesByUserId(userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.getUserAccessesByUserId.replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func getLockHistoryByLockId(lockId: String) -> RequestModel {
        let path = FaceLockAPIPaths.getLockHistoryByLockId.replacingOccurrences(of: "{doorLockId}", with: lockId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func getLockHistoryByUserId(userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.getLockHistoryByUserId.replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .get)
        return model
    }
    
    static func updateLock(lockId: Int, _ dto: UpdateLockDTO) -> RequestModel {
        let path = FaceLockAPIPaths.updateLock.replacingOccurrences(of: "{doorLockId}", with: String(lockId))
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .put)
        model.body = encodedData
        return model
    }
    
    static func updateSecretLockInfo(lockId: String, _ dto: UpdateSecretLockInfoDTO) -> RequestModel {
        let path = FaceLockAPIPaths.updateSecretInfoLock.replacingOccurrences(of: "{doorLockId}", with: lockId)
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .put)
        model.body = encodedData
        return model
    }
    
    static func updateAccessLock(_ dto: AccessLockDTO) -> RequestModel {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.updateAccessLock, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func deleteLockById(lockId: String) -> RequestModel {
        let path = FaceLockAPIPaths.deleteLockById.replacingOccurrences(of: "{placeId}", with: lockId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .delete)
        return model
    }
    
    static func deleteAccessLock(lockId: String, userId: String) -> RequestModel {
        let path = FaceLockAPIPaths.deleteAccessLock
            .replacingOccurrences(of: "{doorLockId}", with: lockId)
            .replacingOccurrences(of: "{userId}", with: userId)
        let model = RequestModel(basePath: serverAPI, path: path, httpMethod: .delete)
        return model
    }
    
    //MARK: - Place
    
    static func createPlace(_ dto: CreatePlaceDTO) -> RequestModel {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.createPlace, httpMethod: .post)
        model.body = encodedData
        return model
    }
    
    static func getPlaces() -> RequestModel {
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.getPlaces, httpMethod: .get)
        return model
    }
    
    static func createSecretInfoDoorLock(_ dto: CreateLockSecretInfoDTO) -> RequestModel {
        let encodedData = try? JSONEncoder().encode(dto)
        let model = RequestModel(basePath: serverAPI, path: FaceLockAPIPaths.createSecretInfoDoorLock, httpMethod: .post)
        model.body = encodedData
        return model
    }
}

extension FaceLockAPIRequestFactory {
    static private func convertImagesToBodyData(boundary: String, _ images: [UIImage]) -> Data {
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
        return body as Data
    }
}
