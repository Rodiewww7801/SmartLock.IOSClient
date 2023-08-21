//
//  GetUserPhotoByPhotoIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import UIKit

protocol GetUserPhotoByPhotoIdCommandProtocol {
    func execute(photoId: String, _ completion: @escaping (Result<UIImage, Error>) -> Void)
}
