//
//  CreateUserViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

class CreateUserViewModel {
    private let createUserCommand: CreateUserCommandProtocol
    
    init() {
        self.createUserCommand = CommandsFactory.createUserCommand()
    }
    
    func createUser(_ createUserDTO: CreateUserRequestDTO, _ completion: @escaping (Bool) -> Void) {
        createUserCommand.execute(createUserDTO, { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        })
    }
}
