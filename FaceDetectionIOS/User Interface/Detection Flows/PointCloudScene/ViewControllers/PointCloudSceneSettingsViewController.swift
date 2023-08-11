//
//  PointCloudSceneSettingsViewController.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 09.06.2023.
//

import Foundation
import UIKit

class PointCloudSceneSettingsViewController: UIViewController {
    private var tableView: UITableView!
    private var dataSource: [DepthDataSettings] = [.maskFace]
    
    private enum DepthDataSettings {
        case maskFace
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("[DepthDataSceneSettingsViewController] init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[DepthDataSceneSettingsViewController] deinit")
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

extension PointCloudSceneSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingsTableViewCell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.reuseIdentifier, for: indexPath) as! SettingsTableViewCell
        switch dataSource[indexPath.row] {
        case .maskFace:
            settingsTableViewCell.configure(type: .switchCell, settingName: "Switch Toogle")
        }
        
        return settingsTableViewCell
    }
}

extension PointCloudSceneSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
