//
//  GetUserPhotosInfoCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

protocol GetUserPhotosInfoCommandProtocol {
    func execute(_ completion: @escaping (Result<[PhotoInfoDTO], Error>) -> Void)
}
