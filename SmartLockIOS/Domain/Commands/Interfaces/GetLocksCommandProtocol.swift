//
//  GetLocksCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

protocol GetLocksCommandProtocol {
    func execute(_ completion: @escaping (Result<GetLocksResponseDTO, Error>) -> Void)
}
