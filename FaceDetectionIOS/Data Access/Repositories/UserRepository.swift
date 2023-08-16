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
    private var getUsersCommand: GetUsersCommandProtocol
    
    init() {
        self.getUserCommand = CommandsFactory.getUserCommand()
        self.getUserByIdCommand = CommandsFactory.getUserByIdCommand()
        self.getUsersCommand = CommandsFactory.getUsersCommand()
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
    
    func getUsers() async -> [User] {
        let usersDTO = try? await withUnsafeThrowingContinuation { continuation in
            getUsersCommand.execute { result in
                continuation.resume(with: result)
            }
        }
        
        guard let usersDTO = usersDTO else { return [] }
        let users = usersDTO.users.map { User(id: $0.id,
                                              username: $0.username,
                                              email: $0.email,
                                              firstName: $0.firstName,
                                              lastName: $0.lastName,
                                              role: User.Role(rawValue: $0.status) ?? .user)}
        return users
    }
}
