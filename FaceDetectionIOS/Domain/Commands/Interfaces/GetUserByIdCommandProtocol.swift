//
//  GetUserByIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

protocol GetUserByIdCommandProtocol {
    func execute(userId: String, _ completion: @escaping (Result<UserDTO,Error>) -> Void)
}
