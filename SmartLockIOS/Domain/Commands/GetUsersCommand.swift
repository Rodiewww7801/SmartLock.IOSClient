//
//  GetUsersCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class GetUsersCommand: GetUsersCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.adminGetUsersRequest()
        networkingSerivce.request(requestModel, completion)
    }
}
