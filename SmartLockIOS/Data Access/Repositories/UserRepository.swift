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
    private var adminGetUserPhotosInfoCommand: AdminGetUserPhotosInfoCommandProtocol
    private var adminGetUserPhotoByPhotoIdCommand: AdminGetUserPhotoByPhotoIdCommandProtocol
    private var getUserPhotosInfoCommand: GetUserPhotosInfoCommandProtocol
    private var getUserPhotoByPhotoIdCommand: GetUserPhotoByPhotoIdCommandProtocol
    
    init() {
        self.getUserCommand = CommandsFactory.getUserCommand()
        self.getUserByIdCommand = CommandsFactory.getUserByIdCommand()
        self.getUsersCommand = CommandsFactory.getUsersCommand()
        self.adminGetUserPhotosInfoCommand = CommandsFactory.getAdminUserPhotosInfoCommand()
        self.adminGetUserPhotoByPhotoIdCommand = CommandsFactory.getAdminUserPhotoByPhotoIdCommand()
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
    
    func getUsersInfo() async -> [UserInfo] {
        let users = await self.getUsers()
        var userInfos = [UserInfo]()
        await withTaskGroup(of: UserInfo?.self) { taskGroup in
            users.forEach { user in
                taskGroup.addTask { [weak self] in
                    print("[UserRepository] start async operation to get UserInfo")
                    if let photoInfo = await self?.getUserPhotosInfo(userId: user.id).first {
                        let userImage = await self?.getUserPhoto(userId: user.id, photoId: String(photoInfo.id))
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
        
        return userInfos.sorted(by: { $0.user.email < $1.user.email })
    }
    
    func getUserInfo() async -> UserInfo? {
        
        let user = await getUser()
        let userPhoto = (await getUserPhotos()).first
        if let user = user {
            return UserInfo(user: user, photo: userPhoto?.image)
        }
        return nil
    }
    
    func getUserPhoto(userId: String, photoId: String) async -> UIImage? {
        let userImage = try? await withUnsafeThrowingContinuation { continuation in
            adminGetUserPhotoByPhotoIdCommand.execute(userId: userId, photoId: photoId) { result in
                continuation.resume(with: result)
            }
        }
        
        return userImage
    }
    
    func getUserPhoto(photoId: String) async -> UIImage? {
        let userImage = try? await withUnsafeThrowingContinuation { continuation in
            getUserPhotoByPhotoIdCommand.execute(photoId: photoId) { result in
                continuation.resume(with: result)
            }
        }
        
        return userImage
    }
    
    
    func getUserPhotosInfo(userId: String) async -> [PhotoInfoDTO] {
        let userPhotosInfoDTO = try? await withUnsafeThrowingContinuation { continuation in
            adminGetUserPhotosInfoCommand.execute(userId: userId) { result in
                continuation.resume(with: result)
            }
        }
        
        return userPhotosInfoDTO ?? []
    }
    
    func getUserPhotosInfo() async -> [PhotoInfoDTO] {
        let userPhotosInfoDTO = try? await withUnsafeThrowingContinuation { continuation in
            getUserPhotosInfoCommand.execute() { result in
                continuation.resume(with: result)
            }
        }
        
        return userPhotosInfoDTO ?? []
    }
    
    func getUserPhotos(userId: String) async -> [Photo] {
        var userPhotos = [Photo]()
        let photosInfo = await self.getUserPhotosInfo(userId: userId)
        await withTaskGroup(of: Photo?.self) { taskGroup in
            photosInfo.forEach { photoInfo in
                taskGroup.addTask { [weak self] in
                    let photo = await self?.getUserPhoto(userId: userId, photoId: String(photoInfo.id))
                    if let photo = photo {
                        return Photo(image: photo, info: photoInfo)
                    } else {
                        return nil
                    }
                }
            }
            
            for await value in taskGroup {
                if let value = value {
                    userPhotos.append(value)
                }
            }
        }
        
        return userPhotos
    }
    
    func getUserPhotos() async -> [Photo] {
        var userPhotos = [Photo]()
        let photosInfo = await self.getUserPhotosInfo()
        await withTaskGroup(of: Photo?.self) { taskGroup in
            photosInfo.forEach { photoInfo in
                taskGroup.addTask { [weak self] in
                    let photo = await self?.getUserPhoto(photoId: String(photoInfo.id))
                    if let photo = photo {
                        return Photo(image: photo, info: photoInfo)
                    } else {
                        return nil
                    }
                }
            }
            
            for await value in taskGroup {
                if let value = value {
                    userPhotos.append(value)
                }
            }
        }
        
        return userPhotos
    }
}
