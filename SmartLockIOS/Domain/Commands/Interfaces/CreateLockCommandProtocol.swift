//
//  CreateLockCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation

protocol CreateLockCommandProtocol {
    func execute(_ dto: CreateLockRequestDTO, _ completion: @escaping (Result<Void, Error>) -> Void)
}
