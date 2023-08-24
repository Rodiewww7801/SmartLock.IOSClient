//
//  UserHistroryViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation
import UIKit

class UserHistroryViewController: UIViewController {
    private var tableView: UserHistoryTableView!
    private var viewModel: UserHistoryViewModel
    private var loadingScreen = FDLoadingScreen()
    private var sections: [String] = []
    
    init(with viewModel: UserHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        
        self.configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    private func loadData() {
        loadingScreen.show(on: self.view)
        viewModel.loadData { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadingScreen.stop()
                self.tableView.dataSource = self.viewModel.dataSource
                self.tableView.reloadData()
            }
        }
    }
    
    private func configureTableView() {
        self.tableView = UserHistoryTableView()
        self.tableView.dataSource = viewModel.dataSource
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
}

