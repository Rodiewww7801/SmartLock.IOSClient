//
//  AuthenticationViewModel.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

protocol AuthenticationViewModelDelegate {
    func onLogin(_ email: String, password: String, _ completion: @escaping ((Bool, Error?)->()))
}

class AuthenticationViewModel: AuthenticationViewModelDelegate {
    private var loginCommand: LoginCommandProtocol
    
    init() {
        self.loginCommand = CommandsFactory.loginCommand()
    }
    
    func onLogin(_ email: String, password: String, _ completion: @escaping ((Bool, Error?) -> ())) {
        let loginRequestDTO = LoginRequestDTO(email: email, password: password)
        loginCommand.execute(with: loginRequestDTO) { result in
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion(false, failure)
            }
        }
    }
}
