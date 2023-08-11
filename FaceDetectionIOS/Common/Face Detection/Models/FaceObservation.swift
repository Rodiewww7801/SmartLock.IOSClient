//
//  FaceObservation.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 22.07.2023.
//

import Foundation

enum FaceObservation<T> {
    case faceFound(T)
    case faceNotFound
    case errored(Error)
}
