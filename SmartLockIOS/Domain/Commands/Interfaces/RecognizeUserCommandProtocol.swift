//
//  RecognizeUserCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 21.08.2023.
//

import UIKit

protocol RecognizeUserCommandProtocol {
    func execute(images: [UIImage], _ completion: @escaping (Result<Void, Error>) -> Void)
}

