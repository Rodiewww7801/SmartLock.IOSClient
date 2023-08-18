//
//  UserManagmentViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import UIKit

class UserManagmentViewModel {
    var userId: String
    var userInfo: UserInfo?
    var addUserPhotosCommand: AddUserPhotosCommandProtocol
    var userRepository: UserRepositoryProtocol
    var deleteUserCommand: DeleteUserCommandProtocol
    
    init(userId: String) {
        self.userId = userId
        self.addUserPhotosCommand = CommandsFactory.addUserPhotosCommand()
        self.userRepository = RepositoryFactory.userRepository()
        self.deleteUserCommand = CommandsFactory.deleteUserCommand()
    }
    
    func loadImages(images: [UIImage], _ completion: @escaping (Bool)->Void) {
        addUserPhotosCommand.execute(userId: userId, images: images, { result in
            switch result {
            case .success(_):
                print("[UserManagmentViewModel]: messages successfully loaded")
                completion(true)
            case .failure(let error):
                completion(false)
                print("[UserManagmentViewModel]: messages failed to load \(error)")
            }
        })
    }
    
    func loadData(_ completion: @escaping ()->() ) {
        Task { [weak self] in
            guard let self = self else { return }
            self.userInfo = await self.userRepository.getUserInfo().first(where: { $0.user.id == self.userId })
            completion()
        }
    }
    
    func deleteUser(_ completion: @escaping ((Bool)->Void)) {
        deleteUserCommand.execute(userId: userId) { result in
            switch result {
            case .success():
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
