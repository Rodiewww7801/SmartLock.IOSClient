//
//  PhotoListViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import UIKit

class PhotoListViewModel {
    private let userId: String
    private var userRepository: UserRepositoryProtocol
    private var deletePhotoByPhtotoIdCommand: DeletePhotoByPhtotoIdCommandProtocol
    private var addUserPhotosCommand: AddUserPhotosCommandProtocol
    
    var dataSource: [Photo] = []
    
    init(userId: String) {
        self.userId = userId
        self.userRepository = RepositoryFactory.userRepository()
        self.deletePhotoByPhtotoIdCommand = CommandsFactory.deletePhotoByPhtotoIdCommand()
        self.addUserPhotosCommand = CommandsFactory.addUserPhotosCommand()
    }
    
    func loadData(_ completion: @escaping ([Photo]) -> Void) {
        Task { [weak self] in
            guard let self = self else { return }
            self.dataSource = await self.userRepository.getUserPhotos(userId: self.userId)
            completion(self.dataSource)
        }
    }
    
    func delete(userId: String, photoId: Int, _ completion: @escaping (Bool) -> Void) {
        deletePhotoByPhtotoIdCommand.execute(userId: userId, photoId: photoId) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    func loadImages(images: [UIImage], _ completion: @escaping (Bool)->Void) {
        let compressedImages = images.compactMap { $0.jpegCompress(.high) }
        addUserPhotosCommand.execute(userId: userId, images: compressedImages, { result in
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
}
