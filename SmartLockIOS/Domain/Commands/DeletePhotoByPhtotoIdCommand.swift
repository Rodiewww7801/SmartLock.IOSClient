//
//  DeletePhotoByPhtotoIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import Foundation

class DeletePhotoByPhtotoIdCommand: DeletePhotoByPhtotoIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, photoId: Int, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.adminDeleteUserByPhotoId(userId: userId, photoId: photoId)
        networkingSerivce.authRequest(requestModel, { result in
            switch result {
            case .success(_):
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
