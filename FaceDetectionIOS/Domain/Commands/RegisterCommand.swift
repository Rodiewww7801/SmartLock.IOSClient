//
//  RegisterCommand.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

class RegisterCommand: RegisterCommandProtocol {
    private let networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(with model: RegisterRequestDTO, _ completion: @escaping (Result<Bool,Error>) -> ()) {
        guard let requestModel = FaceLockAPIRequestFactory.createRegisterRequest(with: model) else { return }
        networkingSerivce.request(requestModel) { result in
            switch result {
            case .success(_):
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
