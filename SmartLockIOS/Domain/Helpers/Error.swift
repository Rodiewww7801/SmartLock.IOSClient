//
//  Error.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import Foundation

enum ErrorWithMessage: Error {
    case message(String)
}
