//
//  FaceLockAPIPaths.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

enum FaceLockAPIPaths {
    //MARK: - AdminUser
    static let adminCreateUser = "/api/AdminUser/CreateUser"
    static let adminAddUserPhotos = "/api/AdminUser/{userId}/AddUserPhotos"
    static let adminGetUsers = "/api/AdminUser/GetUsers"
    static let adminGetUser = "/api/AdminUser/GetUser/{userId}"
    static let adminGetUserPhoto = "/api/AdminUser/{userId}/GetUserPhoto/{faceId}"
    static let adminGetUserPhotos = "/api/AdminUser/{userId}/GetUserPhotos"
    static let adminGetUserPhotosInfo = "/api/AdminUser/{userId}/GetUserPhotosInfo"
    static let adminUpdateUser = "/api/AdminUser/{userId}/UpdateUser"
    static let adminDeleteUser = "/api/AdminUser/{userId}/DeleteUser"
    static let adminDeleteUserPhotos = "/api/AdminUser/{userId}/DeleteUserPhotos"
    
    // MARK: - Authentication
    static let register = "/api/Authentication/register"
    static let login = "/api/Authentication/login"
    static let refresh = "/api/Authentication/refresh"
    static let logout = "/api/Authentication/logout"
    
    //MARK: - User
    static let getUserInfo = "/api/User/GetUserInfo"
    static let getUserVisits = "/api/User/GetUserVisits"
    static let getUserAccesses = "/api/User/GetUserAccesses"
    static let getUserHistories = "/api/User/GetUserHistories"
    static let updateAccount = "/api/User/UpdateAccount"
    static let deleteAccount = "/api/User/DeleteAccount"
}
