//
//  AuthenticationSceneCoordinatorOutput.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

protocol AuthenticationSceneCoordinatorOutput {
    var showMainView: (()->Void)? { get }
}
