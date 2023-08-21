//
//  UserListViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

class UserListViewController: UIViewController {
    private var tableView: UITableView!
    private var viewModel: UserListViewModel
    private var loadingScreen = FDLoadingScreen()
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
        
        self.configureNavigationList()
        self.configureAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadModel()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            self.onBackTapped?()
        }
    }
    
    private func loadModel() {
        loadingScreen.show(on: self.view)
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

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userInfo = self.viewModel.dataSource[indexPath.row]
        let cell = UserInfoViewCell()
        cell.configure()
        cell.updateData(userInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userInfo = viewModel.dataSource[indexPath.row]
        self.onUserSelected?(userInfo.user.id)
    }
}

extension UserListViewController: ModalPresentedViewDelegate {
    func onViewWillDisappear() {
        self.loadModel()
    }
}
