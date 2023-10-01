//
//  SettingsTableViewCell.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 09.06.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = "SettingsTableViewCell"
    enum SettingsTableViewCellType {
        case switchCell
    }
    
    var toggleSwitchAction: (()->())?
    var settingType: SettingsTableViewCellType?
    var settingName: String?
    private(set) var toggleSwitch: UISwitch!
    private var label: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: SettingsTableViewCellType, settingName: String) {
        self.settingType = type
        self.settingName = settingName
        switch type {
        case .switchCell:
            configureSwitchCell()
        }
    }
    
    func toggleSwitchState() {
        DispatchQueue.main.async {
            let state = !self.toggleSwitch.isOn
            self.toggleSwitch.setOn(state, animated: true)
            self.toggleSwitchTapped()
        }
    }
    
    func setSwitchState(_ state: Bool, animated: Bool = false) {
        DispatchQueue.main.async {
            self.toggleSwitch.setOn(state, animated: animated)
        }
    }
    
    private func configureSwitchCell() {
        self.label = UILabel()
        self.label.text = settingName
        
        self.contentView.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
        
        self.label.font = .systemFont(ofSize: 16)
        self.toggleSwitch = UISwitch()
        self.toggleSwitch.isOn = false
        self.toggleSwitch.addTarget(self, action: #selector(toggleSwitchTapped), for: .valueChanged)
        
        self.contentView.addSubview(toggleSwitch)
        self.toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.toggleSwitch.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        self.toggleSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        self.toggleSwitch.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc private func toggleSwitchTapped() {
        self.toggleSwitchAction?()
    }
}
