//
//  Data + Extension.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 14.08.2023.
//

import Foundation

extension Data {
    func decodeJSON() throws -> [String:Any] {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: []) as! [String:Any]
            return json
        } catch {
            throw error
        }
    }
}
