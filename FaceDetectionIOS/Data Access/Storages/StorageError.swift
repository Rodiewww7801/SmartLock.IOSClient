//
//  StorageError.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

enum StorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case emptyResponseError
    case conversionError
    case unhandledError(message: String)
}
