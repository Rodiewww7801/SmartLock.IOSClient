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
    static let adminDeleteUserPhotoByPhotoId = "/api/AdminUser/{userId}/DeleteUserPhoto/{faceId}"
    
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
    static let getUserPhotosInfo = "/api/User/GetUserPhotosInfo"
    static let getUserPhotos = "/api/User/GetUserPhoto/{faceId}"
    
    //MARK: - Recognition
    static let recognizeUser = "/api/Recognition/RecognizeUser"
    static let recognizeUserForDoorLock = "/api/Recognition/{doorLockId}/RecognizeUserForDoorLock"
    
    //MARK: - Lock
    static let createLock = "/api/DoorLock/CreateDoorLock"
    static let createAccessLock = "/api/DoorLock/CreateAccessDoorLock"
    static let getLocks = "/api/DoorLock/GetDoorLocks"
    static let getLockById = "/api/DoorLock/GetDoorLock/{doorLockId}"
    static let getUserAccessesByLockId = "/api/DoorLock/GetUserAccessesByDoorLockId/{doorLockId}"
    static let getUserAccessesByUserId = "/api/DoorLock/GetUserAccessesByUserId/{userId}"
    static let getLockHistoryByLockId = "/api/DoorLock/GetDoorLockHistoryByDoorLockId/{doorLockId}"
    static let getLockHistoryByUserId = "/api/DoorLock/GetDoorLockHistoryByUserId/{userId}"
    static let updateLock = "/api/DoorLock/UpdateDoorLock/{doorLockId}"
    static let updateAccessLock = "/api/DoorLock/UpdateAccessDoorLock"
    static let deleteLockById = "/api/DoorLock/DeleteDoorLock/{placeId}"
    static let deleteAccessLock = "/api/DoorLock/{doorLockId}/DeleteAccessDoorLock/{userId}"
    
    //MARK: - Place
    static let createPlace = "/api/Place/CreatePlace"
    static let getPlaces = "/api/Place/GetPlaces"
    static let getPlaceById = "api/Place/GetPlace/{placeId}"
    static let updatePlace = "/api/Place/UpdatePlace/{placeId}"
}
