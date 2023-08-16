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
}
