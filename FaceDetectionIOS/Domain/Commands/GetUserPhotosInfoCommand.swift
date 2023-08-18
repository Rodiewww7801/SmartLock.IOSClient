//
//  GetUserPhotosInfoCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import Foundation

class GetUserPhotosInfoCommand: GetUserPhotosInfoCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, _ completion: @escaping (Result<[PhotoInfoDTO], Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.createAdminGetUserPhotosInfo(userId: userId)
        networkingSerivce.request(requestModel, completion)
    }
}
