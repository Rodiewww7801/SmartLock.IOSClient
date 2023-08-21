//
//  DeletePhotoByPhtotoIdCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import Foundation

class DeletePhotoByPhtotoIdCommand: DeletePhotoByPhtotoIdCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, photoId: Int, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.adminDeleteUserByPhotoId(userId: userId, photoId: photoId)
        networkingSerivce.request(requestModel, completion)
    }
}
