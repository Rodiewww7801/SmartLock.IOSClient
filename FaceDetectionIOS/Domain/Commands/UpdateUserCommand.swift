//
//  UpdateUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

class UpdateUserCommand: UpdateUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(user: User, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let dto = UpdateUserDTO(username: user.username, email: user.email, firstName: user.firstName, lastName: user.lastName)
        let requestModel = FaceLockAPIRequestFactory.createUpdateUserRequest(dto)
        networkingSerivce.request(requestModel, completion)
    }
}
