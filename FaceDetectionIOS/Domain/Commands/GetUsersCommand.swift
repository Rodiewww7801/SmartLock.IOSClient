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
        guard let requestModel = FaceLockAPIRequestFactory.createAdminGetUsersRequest() else {
            completion(.failure(NetworkingError.failedToCreateRequestModel()))
            return
        }
        networkingSerivce.request(requestModel, completion)
    }
}
