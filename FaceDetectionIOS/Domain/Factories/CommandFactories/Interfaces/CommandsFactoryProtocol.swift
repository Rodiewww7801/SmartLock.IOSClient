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
}
