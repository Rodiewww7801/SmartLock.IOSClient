//
//  GetUserAccessesByUserIdCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

protocol GetUserAccessesByUserIdCommandProtocol {
    func execute(userId: String, _ completion: @escaping (Result<GetUserLockAccessResponseDTO, Error>) -> Void) 
}
