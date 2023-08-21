//
//  GetUserPhotoByPhotoIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import UIKit

class GetUserPhotoByPhotoIdCommand: GetUserPhotoByPhotoIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(photoId: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getUserPhotos(photoId: photoId)
        networkingSerivce.request(requestModel) { (result: Result<Data,Error>) in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
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
