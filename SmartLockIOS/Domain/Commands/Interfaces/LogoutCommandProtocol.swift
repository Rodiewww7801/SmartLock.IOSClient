//
//  LogoutCommandProtocol.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

protocol LogoutCommandProtocol {
    func execute(_ comletion: @escaping (Result<Bool,Error>) -> ()) 
}
