//
//  RegisterCommandProtocol.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

protocol RegisterCommandProtocol {
    func execute(with model: RegisterRequestDTO, _ completion: @escaping (Result<Bool,Error>) -> ()) 
}
