//
//  DeletePhotoByIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import Foundation

protocol DeletePhotoByPhtotoIdCommandProtocol {
    func execute(userId: String, photoId: Int, _ completion: @escaping (Result<Void, Error>) -> Void)
}
