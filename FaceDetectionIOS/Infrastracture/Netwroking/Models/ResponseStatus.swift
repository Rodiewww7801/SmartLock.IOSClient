//
//  RequestStatus.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

enum ResponseStatus {
    case success
    case failed(NetworkingError)
}
