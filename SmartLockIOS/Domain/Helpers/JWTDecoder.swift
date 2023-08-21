//
//  JWTDecoder.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

class JWTDecoder {
    static func base64UrlDecode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // Add padding if needed
        let padding = base64.count % 4
        if padding > 0 {
            base64 += String(repeating: "=", count: 4 - padding)
        }
        
        return Data(base64Encoded: base64)
    }

    static func decodeJWT(_ token: String) -> Token? {
        let segments = token.components(separatedBy: ".")
        
        guard segments.count > 1,
              let payloadData = base64UrlDecode(segments[1]) else {
            return nil
        }
        
        guard let payload = try? JSONDecoder().decode(Token.self, from: payloadData)
        else {
            return nil
        }
        
        return payload
    }
}
