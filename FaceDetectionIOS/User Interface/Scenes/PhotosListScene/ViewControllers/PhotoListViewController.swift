//
//  PhotoListViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import UIKit

class PhotoListViewController: UIViewController {
    private var tableView: UITableView!
    private var viewModel: PhotoListViewModel
    private var loadingScreen = FDLoadingScreen()
    private var sections: [String] = []
    
    var onBackTapped: (()->Void)?
    var onUserSelected: ((UserInfo)->Void)?
    
    init(with viewModel: PhotoListViewModel) {
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
        self.loadModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 88.0
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    private func onDelete(userId: String, photoId: Int) {
        loadingScreen.show(on: self.view)
        viewModel.delete(userId: userId, photoId: photoId) { isSuccess in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if isSuccess {
                    FDAlert()
                        .createWith(title: "Photo was deleted", message: "photo with \(photoId) id was deleted successfully")
                        .addAction(title: "Ok", style: .default, handler: nil)
                        .present(on: self)
                }
                self.loadingScreen.stop()
                self.loadModel()
            }
        }
    }
}

extension PhotoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userInfo = self.viewModel.dataSource[indexPath.row]
        let cell = PhotoListViewCell()
        cell.configure(userInfo)
        cell.onDeleteAction = onDelete
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
}
