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
}
