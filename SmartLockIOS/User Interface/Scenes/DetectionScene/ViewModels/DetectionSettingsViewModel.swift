//
//  DetectionSettingsViewModel.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 27.09.2023.
//

import Foundation

struct DetectionSettingModel {
    var debugState: Bool = false
    var pointToCloudState: Bool = false
    
    init() {
        
    }
}

class DetectionSettingsViewModel {
    private(set) var model: DetectionSettingModel
    
    var onDebugActionSwitch: ((Bool)->Void)?
    var onPointToCloudSwitch: ((Bool)->Void)?
    
    init() {
        self.model = DetectionSettingModel()
    }
    
    func debugActionSwitch(_ value: Bool) {
        self.model.debugState = value
        onDebugActionSwitch?(value)
    }
    
    func pointToCloudState(_ value: Bool) {
        self.model.pointToCloudState = value
        onPointToCloudSwitch?(value)
    }
}
