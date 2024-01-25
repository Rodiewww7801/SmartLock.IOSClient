//
//  GetUserPhotosInfoCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import Foundation

class AdminGetUserPhotosInfoCommand: AdminGetUserPhotosInfoCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(userId: String, _ completion: @escaping (Result<[PhotoInfoDTO], Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.adminGetUserPhotosInfo(userId: userId)
        networkingSerivce.authRequest(requestModel, completion)
    }
}
