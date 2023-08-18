//
//  AddUserPhotosCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import UIKit

protocol AddUserPhotosCommandProtocol {
    func execute(userId: String, images: [UIImage], _ completion: @escaping (Result<Void, Error>) -> Void)
}
