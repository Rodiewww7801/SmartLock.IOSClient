//
//  PhotoListViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import Foundation

class PhotoListViewModel {
    private let userId: String
    private var userRepository: UserRepositoryProtocol
    private var deletePhotoByPhtotoIdCommand: DeletePhotoByPhtotoIdCommandProtocol
    
    var dataSource: [Photo] = []
    
    init(userId: String) {
        self.userId = userId
        self.userRepository = RepositoryFactory.userRepository()
        self.deletePhotoByPhtotoIdCommand = CommandsFactory.deletePhotoByPhtotoIdCommand()
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
}
