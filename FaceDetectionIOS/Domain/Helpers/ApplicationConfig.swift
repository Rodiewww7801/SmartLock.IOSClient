//
//  ApplicationConfig.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 13.08.2023.
//

import Foundation

enum ApplicationConfigKey {
    static let faceLockAPIUrl = "FACE_LOCK_API_URL"
}

class ApplicationConfig {
    static func getConfigurationValue(for key: String) -> String {
        if let infoDictionary = Bundle.main.infoDictionary {
            if let value = infoDictionary[key] as? String {
                return value
            }
        }
        
        print("[ApplicationConfig]: value for key \(key) is missing")
        return ""
    }
}
