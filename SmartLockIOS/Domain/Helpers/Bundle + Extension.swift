//
//  Bundle + Extension.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 19.08.2023.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
    var buildVersionNumber: String {
        return self.infoDictionary?["CFBundleVersion"] as? String ?? "0.0.0"
    }
}
