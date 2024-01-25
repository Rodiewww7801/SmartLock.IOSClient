//
//  GetUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class GetUserCommand: GetUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ completion: @escaping (Result<UserDTO, Error>) -> Void) {
        guard let requestModel = FaceLockAPIRequestFactory.getUserInfo() else { return }
        networkingSerivce.authRequest(requestModel, completion)
    }
}
