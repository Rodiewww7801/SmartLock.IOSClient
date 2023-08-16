//
//  MainListViewController.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 07.06.2023.
//

import Foundation
import UIKit

class MainListViewController: UIViewController {
    var tableView: UITableView!
    var viewModel: MainListViewModel
    private var topStackView: UIStackView!
    private var logoutButton: UIButton!
    private var loadingScreen = FDLoadingScreen()
    
    init(with viewModel: MainListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        
        self.configureNavigationList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingScreen.show(on: self.view)
        viewModel.configure { [weak self] in
            DispatchQueue.main.async {
                self?.loadingScreen.stop()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureNavigationList() {
        self.tableView = UITableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func configreTopStackView() {
        
    }
}

extension MainListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mainListDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var configuration = UIListContentConfiguration.cell()
        let title = self.viewModel.mainListDataSource[indexPath.row].name
        let attrString = NSAttributedString(string: title, attributes: [.foregroundColor: UIColor.black])
        configuration.attributedText = attrString
        cell.contentConfiguration = configuration
        return cell
    }
}

extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.mainListDataSource[indexPath.row].link?()
    }
}
