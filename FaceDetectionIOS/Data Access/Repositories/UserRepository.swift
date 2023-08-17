//
//  UserRepository.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation
import UIKit

class UserRepository: UserRepositoryProtocol {
    private var getUserCommand: GetUserCommandProtocol
    private var getUserByIdCommand: GetUserByIdCommandProtocol
    private var getUsersCommand: GetUsersCommandProtocol
    private var getUserPhotosInfoCommand: GetUserPhotosInfoCommandProtocol
    private var getUserPhotoByPhotoIdCommand: GetUserPhotoByPhotoIdCommandProtocol
    
    init() {
        self.getUserCommand = CommandsFactory.getUserCommand()
        self.getUserByIdCommand = CommandsFactory.getUserByIdCommand()
        self.getUsersCommand = CommandsFactory.getUsersCommand()
        self.getUserPhotosInfoCommand = CommandsFactory.getUserPhotosInfoCommand()
        self.getUserPhotoByPhotoIdCommand = CommandsFactory.getUserPhotoByPhotoIdCommand()
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
    
    func getUserInfo() async -> [UserInfo] {
        let users = await self.getUsers()
        var userInfos = [UserInfo]()
        await withTaskGroup(of: UserInfo?.self) { taskGroup in
            users.forEach { user in
                taskGroup.addTask { [weak self] in
                    print("[UserRepository] start async operation to get UserInfo")
                    if let photosInfo = await self?.getUserPhotosInfo(userId: user.id) {
                        let userImage = await self?.getUserPhoto(userId: user.id, photoId: String(photosInfo.id))
                        print("[UserRepository] async operation recived UserInfo")
                        return UserInfo(user: user, photo: userImage)
                    }
                    return UserInfo(user: user)
                }
            }
            
            for await value in taskGroup {
                if let value = value {
                    print("[UserRepository] async operation returned UserInfo")
                    userInfos.append(value)
                }
            }
        }
        
        return userInfos
    }
    
    func getUserPhoto(userId: String, photoId: String) async -> UIImage? {
        let userImage = try? await withUnsafeThrowingContinuation { continuation in
            getUserPhotoByPhotoIdCommand.execute(userId: userId, photoId: photoId) { result in
                continuation.resume(with: result)
            }
        }
        
        return userImage
    }
    
    func getUserPhotosInfo(userId: String) async -> PhotoInfoResponseDTO? {
        let userPhotosInfoDTO = try? await withUnsafeThrowingContinuation { continuation in
            getUserPhotosInfoCommand.execute(userId: userId) { result in
                continuation.resume(with: result)
            }
        }
        
        return userPhotosInfoDTO?.first
    }
    
}
