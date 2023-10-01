//
//  DetecetionSceneSettingsViewController.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 09.06.2023.
//

import Foundation
import UIKit

class DetecetionSettingsViewController: UIViewController {
    private var tableView: UITableView!
    private var dataSource: [DepthDataSettings] = [.debugMode, .pointToCloudScene]
    private var viewModel: DetectionSettingsViewModel
    
    private enum DepthDataSettings {
        case debugMode
        case pointToCloudScene
    }
    
    init(viewModel: DetectionSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("[DetecetionSceneSettingsViewController] init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[DetecetionSceneSettingsViewController] deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTableView()
    }
    
    private func configureTableView() {
        self.tableView = UITableView(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.reuseIdentifier)
        
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension DetecetionSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as! SettingsTableViewCell
        switch dataSource[indexPath.row] {
        case .debugMode:
            settingsTableViewCell.configure(type: .switchCell, settingName: "Debug mode")
            settingsTableViewCell.setSwitchState(viewModel.model.debugState)
            settingsTableViewCell.toggleSwitchAction = { [weak self, weak settingsTableViewCell] in
                guard let self = self, let settingsTableViewCell = settingsTableViewCell else { return }
                //settingsTableViewCell.toggleSwitchState()
                viewModel.debugActionSwitch(settingsTableViewCell.toggleSwitch.isOn)
            }
        case .pointToCloudScene:
            settingsTableViewCell.configure(type: .switchCell, settingName: "Point to cloud scene")
            settingsTableViewCell.setSwitchState(viewModel.model.pointToCloudState)
            settingsTableViewCell.toggleSwitchAction = { [weak self, weak settingsTableViewCell] in
                guard let self = self, let settingsTableViewCell = settingsTableViewCell else { return }
                //settingsTableViewCell.toggleSwitchState()
                viewModel.pointToCloudState(settingsTableViewCell.toggleSwitch.isOn)
            }
        }
        
        return settingsTableViewCell
    }
}

extension DetecetionSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell {
            cell.toggleSwitchState()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
