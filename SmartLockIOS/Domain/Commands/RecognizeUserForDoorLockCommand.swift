//
//  RecognizeUserForDoorLockCommand.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 27.08.2023.
//

import Foundation
import UIKit

class RecognizeUserForDoorLockCommand: RecognizeUserForDoorLockCommandProtocol {
    private var networkingSerivce: NetworkingServiceProtocol
    
    init() {
        self.networkingSerivce = NetworkingFactory.networkingService()
    }
    
    func execute(lockId: String, images: [UIImage], _ completion: @escaping (Result<RecognizeUserDTO, Error>) -> Void) {
        let requestModel = FaceLockAPIRequestFactory.recognizeUserForDoorLock(lockId: lockId, images: images)
        networkingSerivce.request(requestModel, completion)
    }
}
