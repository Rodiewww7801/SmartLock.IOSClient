//
//  AddUserPhotosCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import UIKit

class AddUserPhotosCommand: AddUserPhotosCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, images: [UIImage], _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.adminAddUserPhotos(userId: userId, images: images)
        networkingSerivce.request(requestModel, completion)
    }
}
