//
//  LoginCommandProtocol.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

protocol LoginCommandProtocol {
    func execute(with model: LoginRequestDTO, _ completion: @escaping (Result<Bool, Error>) -> ())
}
