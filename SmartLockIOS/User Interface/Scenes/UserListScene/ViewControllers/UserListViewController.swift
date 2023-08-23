//
//  UserListViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

class UserListViewController: UIViewController {
    private var tableView: UserListTableView!
    private var loadingScreen = FDLoadingScreen()
    private var viewModel: UserListViewModel
    private var sections: [String] = []
    
    var onBackTapped: (()->Void)?
    var onUserSelected: ((String)->Void)?
    var onAddButtonAction: (()->Void)?
    
    init(with viewModel: UserListViewModel) {
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
            if user.role == .admin {
                DispatchQueue.main.async {
                    self?.configureAddButton()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            self.onBackTapped?()
        }
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
        self.tableView = UserListTableView()
        self.tableView.onUserSelected = self.onUserSelected
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUserTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addUserTapped() {
        self.onAddButtonAction?()
    }
}

extension UserListViewController: ModalPresentedViewDelegate {
    func onViewWillDisappear() {
        self.loadData()
    }
}
