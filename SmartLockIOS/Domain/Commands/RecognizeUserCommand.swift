//
//  RecognizeUserCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 21.08.2023.
//

import UIKit

class RecognizeUserCommand: RecognizeUserCommandProtocol {
    private var networkingSerivce: NetworkingServiceProotocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(images: [UIImage], _ completion: @escaping (Result<Void, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.recognizeUser(images: images)
        networkingSerivce.request(requestModel, completion)
    }
}
