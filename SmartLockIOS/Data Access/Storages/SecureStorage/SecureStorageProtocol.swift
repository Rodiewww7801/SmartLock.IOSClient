//
//  SecureStorageProtocol.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

protocol SecureStorageProtocol {
    func setValue(_ value: String, for userAccount: String) throws
    func getValue(for userAccount: String) throws -> String?
    func removeValue(for userAccount: String) throws
    func removeAllValues() throws
}
