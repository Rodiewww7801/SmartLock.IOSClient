//
//  PhotoListViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import UIKit
import PhotosUI

class PhotoListViewController: UIViewController {
    private var tableView: UITableView!
    private var viewModel: PhotoListViewModel
    private var loadingScreen = FDLoadingScreen()
    private var sections: [String] = []
    
    var onBackTapped: (()->Void)?
    var onUserSelected: ((User)->Void)?
    
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
        self.configureAddButton()
        self.loadData()
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
    
    private func loadData() {
        loadingScreen.show(on: self.view)
        viewModel.loadData { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.loadingScreen.stop()
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
                self.loadData()
            }
        }
    }
    
    private func configureAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUserPhotos))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addUserPhotos() {
        configurePhotoPickerViewController()
    }
    
    private func configurePhotoPickerViewController() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = .max
        let viewController = PHPickerViewController(configuration: configuration)
        viewController.delegate = self
        self.present(viewController, animated: true)
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

extension PhotoListViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        var images = [UIImage]()
        let dispatchGroup = DispatchGroup()
        results.forEach { result in
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer {
                    dispatchGroup.leave()
                }
                guard let image = reading as? UIImage, error == nil else {
                    print("[UserManagmentViewController]: \(String(describing: error))")
                    return
                }
                images.append(image)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in //todo: global
            guard let self = self else { return }
            if !images.isEmpty {
                self.loadingScreen.show(on: self.view)
                self.viewModel.loadImages(images: images) { isSuccess in
                    if isSuccess {
                        DispatchQueue.main.async {
                            FDAlert()
                                .createWith(title: "Success", message: "\(images.count) was added successfully")
                                .addAction(title: "Ok", style: .default, handler: {
                                    self.loadData()
                                })
                                .present(on: self)
                        }
                    }
                    self.loadingScreen.stop()
                }
            }
            picker.dismiss(animated: true)
        }
    }
}
