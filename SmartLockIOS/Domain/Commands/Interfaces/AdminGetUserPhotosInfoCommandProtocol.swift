//
//  GetUserPhotosInfoCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import Foundation

protocol AdminGetUserPhotosInfoCommandProtocol {
    func execute(userId: String, _ completion: @escaping (Result<[PhotoInfoDTO], Error>) -> Void)
}
