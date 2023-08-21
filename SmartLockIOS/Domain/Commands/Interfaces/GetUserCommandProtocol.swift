//
//  GetUserCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

protocol GetUserCommandProtocol {
    func execute(_ completion: @escaping (Result<UserDTO, Error>) -> Void)
}
