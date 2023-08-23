//
//  CommandsFactory.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

class CommandsFactory: CommandsFactoryProtocol {
    static func registerCommand() -> RegisterCommandProtocol {
        return RegisterCommand()
    }
    
    static func loginCommand() -> LoginCommandProtocol {
        return LoginCommand()
    }
    
    static func logoutCommand() -> LogoutCommandProtocol {
        return LogoutCommand()
    }
    
    static func getUserCommand() -> GetUserCommandProtocol {
        return GetUserCommand()
    }
    
    static func getUserByIdCommand() -> GetUserByIdCommand {
        return GetUserByIdCommand()
    }
    
    static func createUserCommand() -> CreateUserCommandProtocol {
        return CreateUserCommand()
    }
    
    static func getUsersCommand() -> GetUsersCommandProtocol {
        return GetUsersCommand()
    }
    
    static func getAdminUserPhotosInfoCommand() -> AdminGetUserPhotosInfoCommandProtocol {
        return AdminGetUserPhotosInfoCommand()
    }
    
    static func getAdminUserPhotoByPhotoIdCommand() -> AdminGetUserPhotoByPhotoIdCommandProtocol {
        return AdminGetUserPhotoByPhotoIdCommand()
    }
    
    static func addUserPhotosCommand() -> AddUserPhotosCommandProtocol {
        return AddUserPhotosCommand()
    }
    
    static func deletePhotoByPhtotoIdCommand() -> DeletePhotoByPhtotoIdCommandProtocol {
        return DeletePhotoByPhtotoIdCommand()
    }
    
    static func adminDeleteUserCommand() -> AdminDeleteUserCommand {
        return AdminDeleteUserCommand()
    }
    
    static func adminUpdateUserCommand() -> AdminUpdateUserCommandProtocol {
        return AdminUpdateUserCommand()
    }
    
    static func updateUserCommand() -> UpdateUserCommandProtocol {
        return UpdateUserCommand()
    }
    
    static func deleteUserCommand() -> DeleteUserCommandProtocol {
        return DeleteUserCommand()
    }
    
    static func getUserPhotosInfoCommand() -> GetUserPhotosInfoCommandProtocol {
        return GetUserPhotosInfoCommand()
    }
    
    static func getUserPhotoByPhotoIdCommand() -> GetUserPhotoByPhotoIdCommandProtocol {
        return GetUserPhotoByPhotoIdCommand()
    }
    
    static func recognizeUserCommand() -> RecognizeUserCommandProtocol {
        return RecognizeUserCommand()
    }
    
    static func getLocksCommand() -> GetLocksCommandProtocol {
        return GetLocksCommand()
    }
    
    static func createLockCommand() -> CreateLockCommandProtocol {
        return CreateLockCommand()
    }
    
    static func getLockByIdCommand() -> GetLockByIdCommandProtocol {
        return GetLockByIdCommand()
    }
    
    static func deleteLockCommand() -> DeleteLockCommandProtocol {
        return DeleteLockCommand()
    }
    
    static func getUserAccessesByLockIdCommand () -> GetUserAccessesByLockIdCommandProtocol {
        return GetUserAccessesByLockIdCommand()
    }
    
    static func deleteAccessLockCommand() -> DeleteAccessLockCommandProtocol {
        return DeleteAccessLockCommand()
    }
    
    static func createAccessLockCommand() -> CreateAccessLockCommandProtocol {
        return CreateAccessLockCommand()
    }
}
