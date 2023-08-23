//
//  LockListTableView.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 21.08.2023.
//

import UIKit

class LockListTableView: UIView {
    private var tableView: UITableView!
    private var viewModel: LockListViewModel
    private var loadingScreen = FDLoadingScreen()
    private var sections: [String] = []
    
    var onLockSelected: ((String)->Void)?
    
    init(with viewModel: LockListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.configureNavigationList()
        self.loadData()
    }
    
    func loadData() {
        loadingScreen.show(on: self)
        viewModel.loadData { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadingScreen.stop()
                self?.tableView.reloadData()
            }
        }
    }
    
    private func configureNavigationList() {
        self.tableView = UITableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 88.0
        
        self.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

extension LockListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userInfo = self.viewModel.dataSource[indexPath.row]
        let cell = LockViewCell()
        cell.configure()
        cell.updateData(userInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}

extension LockListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let lock = viewModel.dataSource[indexPath.row]
        self.onLockSelected?(lock.id)
    }
}
