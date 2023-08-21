//
//  GetUsersCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

protocol GetUsersCommandProtocol {
    func execute(_ completion: @escaping (Result<GetUsersResponseDTO, Error>) -> Void)
}
