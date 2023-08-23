//
//  CreateAccessLockCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation

protocol CreateAccessLockCommandProtocol {
    func execute(_ dto: CreateAccessLockDTO, _ completion: @escaping (Result<Void, Error>) -> Void)
}
