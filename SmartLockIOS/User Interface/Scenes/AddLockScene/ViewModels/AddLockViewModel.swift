//
//  AddLockViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

class AddLockViewModel {
    private let createLockCommand: CreateLockCommandProtocol
    
    init() {
        self.createLockCommand = CommandsFactory.createLockCommand()
    }
    
    func createLock(_ dto: CreateLockRequestDTO, _ completion: @escaping (Bool) -> Void) {
        createLockCommand.execute(dto, { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        })
    }
}
