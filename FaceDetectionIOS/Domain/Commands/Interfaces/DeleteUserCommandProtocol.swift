//
//  DeleteUserCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

protocol DeleteUserCommandProtocol {
    func execute(userId: String, _ completion: @escaping (Result<Void, Error>) -> Void)
}
