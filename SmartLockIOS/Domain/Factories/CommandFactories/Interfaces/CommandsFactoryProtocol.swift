//
//  CommandsFactoryProtocol.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

protocol CommandsFactoryProtocol {
    static func registerCommand() -> RegisterCommandProtocol
    static func loginCommand() -> LoginCommandProtocol
    static func logoutCommand() -> LogoutCommandProtocol
    static func getUserCommand() -> GetUserCommandProtocol
    static func getUserByIdCommand() -> GetUserByIdCommand
    static func createUserCommand() -> CreateUserCommandProtocol
    static func getUsersCommand() -> GetUsersCommandProtocol
    static func getAdminUserPhotosInfoCommand() -> AdminGetUserPhotosInfoCommandProtocol
    static func getAdminUserPhotoByPhotoIdCommand() -> AdminGetUserPhotoByPhotoIdCommandProtocol
    static func addUserPhotosCommand() -> AddUserPhotosCommandProtocol
    static func adminDeleteUserCommand() -> AdminDeleteUserCommand
    static func adminUpdateUserCommand() -> AdminUpdateUserCommandProtocol
    static func deleteUserCommand() -> DeleteUserCommandProtocol
    static func getUserPhotosInfoCommand() -> GetUserPhotosInfoCommandProtocol
    static func getUserPhotoByPhotoIdCommand() -> GetUserPhotoByPhotoIdCommandProtocol
    static func recognizeUserCommand() -> RecognizeUserCommandProtocol
    static func getLocksCommand() -> GetLocksCommandProtocol
    static func createLockCommand() -> CreateLockCommandProtocol
    static func getLockByIdCommand() -> GetLockByIdCommandProtocol
    static func deleteLockCommand() -> DeleteLockCommandProtocol
    static func getUserAccessesByLockIdCommand () -> GetUserAccessesByLockIdCommandProtocol
    static func deleteAccessLockCommand() -> DeleteAccessLockCommandProtocol
    static func createAccessLockCommand() -> CreateAccessLockCommandProtocol
}
