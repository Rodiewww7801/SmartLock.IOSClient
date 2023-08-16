//
//  UserRepository.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class UserRepository: UserRepositoryProtocol {
    private var getUserCommand: GetUserCommandProtocol
    private var getUserByIdCommand: GetUserByIdCommandProtocol
    
    init() {
        self.getUserCommand = CommandsFactory.getUserCommand()
        self.getUserByIdCommand = CommandsFactory.getUserByIdCommand()
    }
    
    func getUser() async -> User? {
        let userDTO = try? await withCheckedThrowingContinuation { continuation in
            getUserCommand.execute { result in
                continuation.resume(with: result)
            }
        }

        guard let userDTO = userDTO else { return nil }
        let user = User(id: userDTO.id,
                        username: userDTO.username,
                        email: userDTO.email,
                        firstName: userDTO.firstName,
                        lastName: userDTO.lastName,
                        role: User.Role(rawValue: userDTO.status) ?? .user)
        return user
    }
    
    func getUser(id: String) async -> User? {
        let userDTO = try? await withUnsafeThrowingContinuation { continuation in
            getUserByIdCommand.execute(userId: id) { result in
                continuation.resume(with: result)
            }
        }
        
        guard let userDTO = userDTO else { return nil }
        let user = User(id: userDTO.id,
                        username: userDTO.username,
                        email: userDTO.email,
                        firstName: userDTO.firstName,
                        lastName: userDTO.lastName,
                        role: User.Role(rawValue: userDTO.status) ?? .user)
        return user
    }
}
