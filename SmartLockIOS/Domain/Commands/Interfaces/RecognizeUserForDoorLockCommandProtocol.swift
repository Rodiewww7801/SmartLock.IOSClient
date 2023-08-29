//
//  RecognizeUserForDoorLockCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 27.08.2023.
//

import Foundation
import UIKit

protocol RecognizeUserForDoorLockCommandProtocol  {
    func execute(lockId: String, images: [UIImage], _ completion: @escaping (Result<RecognizeUserDTO, Error>) -> Void)
}
