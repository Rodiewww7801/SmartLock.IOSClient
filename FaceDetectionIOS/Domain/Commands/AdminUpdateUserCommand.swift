//
//  AdminUpdateUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

class AdminUpdateUserCommand: AdminUpdateUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(user: User, _ completion: @escaping (Result<Void, Error>) -> Void) {
        let dto = AdminUpdateUserDTO(username: user.username, email: user.email, firstName: user.firstName, lastName: user.lastName, status: user.role.rawValue)
        let requestModel = FaceLockAPIRequestFactory.createAdminUpdateUser(userId: user.id, dto)
        networkingSerivce.request(requestModel, completion)
    }
}
