//
//  LockListViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 22.08.2023.
//

import Foundation
import UIKit

class LockListViewController: UIViewController {
    private var tableView: LockListTableView!
    private var viewModel: LockListViewModel
    
    var onBackTapped: (()->Void)?
    var onAddButtonAction: (()->Void)?
    var onLockSelected: ((String)->Void)?
    
    init(with viewModel: LockListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        viewModel.getCurrentUser() { [weak self] user in
            DispatchQueue.main.async {
                if user.role == .admin {
                    self?.configureAddButton()
                }
            }
        }
        configureViews()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            self.onBackTapped?()
        }
    }
    
    private func configureViews() {
        configureTableView()
    }
    
    private func configureTableView() {
        tableView = LockListTableView(with: self.viewModel)
        tableView.onLockSelected = self.onLockSelected
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLockTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addLockTapped() {
        self.onAddButtonAction?()
    }
}

extension LockListViewController: ModalPresentedViewDelegate {
    func onViewWillDisappear() {
        self.tableView.loadData()
    }
}
