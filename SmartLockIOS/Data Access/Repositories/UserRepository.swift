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
    private var recognizeUserCommand: RecognizeUserCommandProtocol
    private var recognizeUserForDoorLockCommand: RecognizeUserForDoorLockCommandProtocol
    
    init() {
        self.getUserCommand = CommandsFactory.getUserCommand()
        self.getUserByIdCommand = CommandsFactory.getUserByIdCommand()
        self.getUsersCommand = CommandsFactory.getUsersCommand()
        self.adminGetUserPhotosInfoCommand = CommandsFactory.getAdminUserPhotosInfoCommand()
        self.adminGetUserPhotoByPhotoIdCommand = CommandsFactory.getAdminUserPhotoByPhotoIdCommand()
        self.getUserPhotosInfoCommand = CommandsFactory.getUserPhotosInfoCommand()
        self.getUserPhotoByPhotoIdCommand = CommandsFactory.getUserPhotoByPhotoIdCommand()
        self.recognizeUserCommand = CommandsFactory.recognizeUserCommand()
        self.recognizeUserForDoorLockCommand = CommandsFactory.recognizeUserForDoorLockCommand()
    }
    
    func getUser() async -> User? {
        
        let userDTOTask = Task(priority: .high) { [weak self] in
            return try? await withUnsafeThrowingContinuation { continuation in
                self?.getUserCommand.execute { result in
                    continuation.resume(with: result)
                }
            }
        }
        let userPhotoTask = Task(priority: .high) { [weak self] in
            return await self?.getUserPhotos()
        }
        let userDTO = await userDTOTask.value
        let userPhoto = await userPhotoTask.value?.first

        guard let userDTO = userDTO else { return nil }
        let user = User(id: userDTO.id, face: userPhoto?.image, username: userDTO.username, email: userDTO.email, firstName: userDTO.firstName, lastName: userDTO.lastName, role: User.Role(rawValue: userDTO.status) ?? .user)
        return user
    }
    
    func getUser(id: String) async -> User? {
        let userDTOTask = Task(priority: .high) { [weak self] in
            return try? await withUnsafeThrowingContinuation { continuation in
                self?.getUserByIdCommand.execute(userId: id) { result in
                   continuation.resume(with: result)
               }
           }
        }
        let userPhotoTask = Task(priority: .high) { [weak self] in
            return await self?.getUserPhotos(userId: id)
        }
        let userDTO = await userDTOTask.value
        let userPhoto = await userPhotoTask.value?.first
        guard let userDTO = userDTO else { return nil }
        let user = User(id: userDTO.id, face: userPhoto?.image, username: userDTO.username, email: userDTO.email, firstName: userDTO.firstName, lastName: userDTO.lastName, role: User.Role(rawValue: userDTO.status) ?? .user)
        return user
    }
    
    func getUser(images: [UIImage]) async -> User? {
        let userDTO = try? await withUnsafeThrowingContinuation { [weak self] continuation in
            self?.recognizeUserCommand.execute(images: images) { result in
                continuation.resume(with: result)
            }
        }
        
        guard let userDTO = userDTO else { return nil }
        var userFace: UIImage? = nil
        if let data = Data(base64Encoded: userDTO.base64UserImage.data) {
            userFace = UIImage(data: data)
        }
       
        let user = User(id: userDTO.id, face: userFace, username: userDTO.username, email: userDTO.email, firstName: userDTO.firstName, lastName: userDTO.lastName, role: User.Role(rawValue: userDTO.status) ?? .user)
        return user
    }
    
    func getUser(lockId: String, images: [UIImage]) async -> User? {
        let userDTO = try? await withUnsafeThrowingContinuation { [weak self] continuation in
            self?.recognizeUserForDoorLockCommand.execute(lockId: lockId, images: images) { result in
                continuation.resume(with: result)
            }
        }
        
        guard let userDTO = userDTO else { return nil }
        var userFace: UIImage? = nil
        if let data = Data(base64Encoded: userDTO.base64UserImage.data) {
            userFace = UIImage(data: data)
        }
       
        let user = User(id: userDTO.id, face: userFace, username: userDTO.username, email: userDTO.email, firstName: userDTO.firstName, lastName: userDTO.lastName, role: User.Role(rawValue: userDTO.status) ?? .user)
        return user
    }
    
    func getUserCardModel(lockId: String, images: [UIImage]) async -> UserCardModel? {
        let userDTO = try? await withUnsafeThrowingContinuation { [weak self] continuation in
            self?.recognizeUserForDoorLockCommand.execute(lockId: lockId, images: images) { result in
                continuation.resume(with: result)
            }
        }
        
        guard let userDTO = userDTO else { return nil }
        var userFace: UIImage? = nil
        if let data = Data(base64Encoded: userDTO.base64UserImage.data) {
            userFace = UIImage(data: data)
        }
       
        let user = UserCardModel(id: userDTO.id, face: userFace, username: userDTO.username, email: userDTO.email, firstName: userDTO.firstName, lastName: userDTO.lastName, role: User.Role(rawValue: userDTO.status) ?? .user, predictionDistance: userDTO.predictionDistance)
        return user
    }
    
    
    func getUsers() async -> [User] {
        let usersDTO = try? await withUnsafeThrowingContinuation { [weak self] continuation in
            self?.getUsersCommand.execute() { result in
                continuation.resume(with: result)
            }
        }.users
        
        var users = [User]()
        guard let usersDTO = usersDTO else { return [] }
        
        await withTaskGroup(of: User?.self) { taskGroup in
            usersDTO.forEach { userDTO in
                taskGroup.addTask { [weak self] in
                    print("[UserRepository] start async operation to get UserInfo")
                    var user = User(id: userDTO.id, username: userDTO.username, email: userDTO.email, firstName: userDTO.firstName, lastName: userDTO.lastName, role: User.Role(rawValue: userDTO.status) ?? .user)
                    if let photo = await self?.getUserPhotos(userId: user.id).first {
                        user.face = photo.image
                    }
                    return user
                }
            }
            
            for await value in taskGroup {
                if let value = value {
                    print("[UserRepository] async operation returned UserInfo")
                    users.append(value)
                }
            }
        }
        
        return users.sorted(by: { $0.email < $1.email })
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
    
    func getUserPhotos(userId: String) async -> [Photo] {
        let photoInfoDTO = try? await withUnsafeThrowingContinuation { [weak self] continuation in
            self?.adminGetUserPhotosInfoCommand.execute(userId: userId) { result in
                continuation.resume(with: result)
            }
        }
        
        var userPhotos = [Photo]()
        await withTaskGroup(of: Photo?.self) { taskGroup in
            photoInfoDTO?.forEach { photoInfo in
                taskGroup.addTask { [weak self] in
                    let photo = await self?.getUserPhoto(userId: userId, photoId: String(photoInfo.id))
                    if let photo = photo {
                        return Photo(image: photo, id: photoInfo.id, imageMimeType: photoInfo.imageMimeType, userId: photoInfo.userId)
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
        let photoInfoDTO = try? await withUnsafeThrowingContinuation { [weak self] continuation in
            self?.getUserPhotosInfoCommand.execute() { result in
                continuation.resume(with: result)
            }
        }
        
        var userPhotos = [Photo]()
        await withTaskGroup(of: Photo?.self) { taskGroup in
            photoInfoDTO?.forEach { photoInfo in
                taskGroup.addTask { [weak self] in
                    let photo = await self?.getUserPhoto(photoId: String(photoInfo.id))
                    if let photo = photo {
                        return Photo(image: photo, id: photoInfo.id, imageMimeType: photoInfo.imageMimeType, userId: photoInfo.userId)
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
