//
//  GetLocksCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

class GetLocksCommand: GetLocksCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(_ completion: @escaping (Result<GetLocksResponseDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.getLocks()
        networkingSerivce.request(requestModel, completion)
    }
}
