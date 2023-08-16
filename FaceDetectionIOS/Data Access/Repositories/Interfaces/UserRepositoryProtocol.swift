//
//  UserRepositoryProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

protocol UserRepositoryProtocol {
    func getUser() async -> User?
    func getUser(id: String) async -> User?
}
