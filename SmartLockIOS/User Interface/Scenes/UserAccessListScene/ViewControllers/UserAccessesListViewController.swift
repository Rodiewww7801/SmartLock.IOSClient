//
//  UserAccessesListViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation
import UIKit

class UserAccessesListViewController: UIViewController {
    private var tableView: UserAccessesTableView!
    private var viewModel: UserAccessesViewModel
    private var loadingScreen = FDLoadingScreen()
    private var sections: [String] = []
    
    var onAddButtonAction: (()->Void)?
    
    init(with viewModel: UserAccessesViewModel) {
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
        self.viewModel.getCurrentUser { [weak self] user in
            DispatchQueue.main.async {
                if user.role == .admin {
                    self?.configureAddButton()
                }
            }
        }
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
                self.tableView.dataSource = self.viewModel.dataSource
                self.tableView.reloadData()
                self.loadingScreen.stop()
            }
        }
    }
    
    private func configureTableView() {
        self.tableView = UserAccessesTableView()
        self.tableView.dataSource = viewModel.dataSource
        self.tableView.onDeleteAction = self.onDeleteAction
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAccessTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addAccessTapped() {
        self.onAddButtonAction?()
    }
    
    private func onDeleteAction(_ lockId: String, _ userId: String) {
        func startDeleteUser() {
            loadingScreen.show(on: self.view)
            viewModel.deleteUserLockAccess(lockId: lockId, userId: userId) { isSuccess in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    loadingScreen.stop()
                    if isSuccess {
                        FDAlert()
                            .createWith(title: "Access was deleted", message: nil)
                            .addAction(title: "Ok", style: .default, handler: {
                                self.loadData()
                            })
                            .present(on: self)
                    }
                }
            }
        }
        let accessModel = viewModel.dataSource.first(where: { $0.lock.id == lockId && $0.user.id == userId})
        guard let firstName = accessModel?.user.firstName,
              let lastName = accessModel?.user.lastName,
              let lockName = accessModel?.lock.name
        else { return }
        FDAlert()
            .createWith(title: "Are you sure you want to delete access \(firstName) \(lastName) for \(lockName)?", message: nil)
            .addAction(title: "Cancel", style: .cancel, handler: nil)
            .addAction(title: "Yes", style: .default, handler: {
                startDeleteUser()
            })
            .present(on: self)
    }
}

extension UserAccessesListViewController: ModalPresentedViewDelegate {
    func onViewWillDisappear() {
        self.loadData()
    }
}
