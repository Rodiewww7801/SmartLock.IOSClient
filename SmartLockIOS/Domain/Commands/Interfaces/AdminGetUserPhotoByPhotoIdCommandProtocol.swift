//
//  GetUserPhotoByPhotoIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import UIKit

protocol AdminGetUserPhotoByPhotoIdCommandProtocol {
    func execute(userId: String, photoId: String, _ completion: @escaping (Result<UIImage, Error>) -> Void)
}
