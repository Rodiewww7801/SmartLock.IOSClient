//
//  Encodable + Extension.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

extension Encodable {
    func jsonEncoder() throws -> [String:Any] {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: encodedData, options: []) as! [String:Any]
            return json
        } catch {
            throw error
        }
    }
}
