//
//  UpdateUserCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

protocol AdminUpdateUserCommandProtocol {
    func execute(user: User, _ completion: @escaping (Result<Void, Error>) -> Void)
}
