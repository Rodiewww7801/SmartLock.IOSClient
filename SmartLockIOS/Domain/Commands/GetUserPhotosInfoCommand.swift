//
//  GetUserPhotosInfoCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

class GetUserPhotosInfoCommand: GetUserPhotosInfoCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ completion: @escaping (Result<[PhotoInfoDTO], Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getUserPhotosInfo()
        networkingSerivce.authRequest(requestModel, completion)
    }
}
