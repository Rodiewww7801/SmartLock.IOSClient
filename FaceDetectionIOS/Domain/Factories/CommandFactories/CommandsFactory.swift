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
    
    static func getUserPhotosInfoCommand() -> GetUserPhotosInfoCommandProtocol {
        return GetUserPhotosInfoCommand()
    }
    
    static func getUserPhotoByPhotoIdCommand() -> GetUserPhotoByPhotoIdCommandProtocol {
        return GetUserPhotoByPhotoIdCommand()
    }
    
    static func addUserPhotosCommand() -> AddUserPhotosCommandProtocol {
        return AddUserPhotosCommand()
    }
    
    static func deletePhotoByPhtotoIdCommand() -> DeletePhotoByPhtotoIdCommandProtocol {
        return DeletePhotoByPhtotoIdCommand()
    }
    
    static func deleteUserCommand() -> DeleteUserCommand {
        return DeleteUserCommand()
    }
}
