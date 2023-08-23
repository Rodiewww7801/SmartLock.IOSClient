//
//  AddUserLockAccessViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation
import UIKit

class AddUserLockAccessViewController: UIViewController {
    private var tableView: UserListTableView!
    private var loadingScreen = FDLoadingScreen()
    private var viewModel: AddUserLockAccessViewModel
    private var sections: [String] = []
    var modalDelegate: ModalPresentedViewDelegate?
    
    var onAddingAccessFinished: (()->Void)?
    
    init(with viewModel: AddUserLockAccessViewModel) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        modalDelegate?.onViewWillDisappear()
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
    
    private func onUserSelected(userId: String) {
        loadingScreen.show(on: self.view)
        viewModel.addUserLockAccess(userId: userId) { [weak self] isSuccess in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if isSuccess {
                    FDAlert()
                        .createWith(title: "Access was created", message: nil)
                        .addAction(title: "Ok", style: .default, handler: {
                            self.dismiss(animated: true)
                        })
                        .present(on: self)
                } else {
                    self.dismiss(animated: true)
                }
                self.loadingScreen.stop()
            }
        }
    }
}
