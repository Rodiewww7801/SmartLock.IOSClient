//
//  RegistrationViewModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

protocol RegistrationViewModelDelegate {
    func onRegister(_ registerModel: RegisterRequestDTO, _ completion: @escaping (Bool, Error?) -> ())
}

class RegistrationViewModel: RegistrationViewModelDelegate {
    private var authenticationCommand: RegisterCommandProtocol
    private var registrationModel: RegisterRequestDTO?
    
    init() {
        self.authenticationCommand = CommandsFactory.registerCommand()
    }
    
    func onRegister(_ registerModel: RegisterRequestDTO, _ completion: @escaping (Bool, Error?) -> ()) {
        authenticationCommand.execute(with: registerModel) { result in
            switch result {
            case .success(_):
                completion(true, nil)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
}
