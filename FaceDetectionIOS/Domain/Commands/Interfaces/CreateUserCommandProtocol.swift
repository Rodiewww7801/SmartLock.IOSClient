//
//  CreateUserCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

protocol CreateUserCommandProtocol {
    func execute(_ dto: CreateUserRequestDTO, _ completion: @escaping (Result<Void, Error>) -> Void)
}
