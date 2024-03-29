//
//  GetUserPhotoByPhotoId.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import UIKit

class AdminGetUserPhotoByPhotoIdCommand: AdminGetUserPhotoByPhotoIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, photoId: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.adminGetUserPhoto(userId: userId, photoId: photoId)
        networkingSerivce.authRequest(requestModel) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    print("[GetUserPhotoByPhotoIdCommand]: FAILED to parse data to UIImage")
                    completion(.failure(NetworkingError.unableToDecode()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
