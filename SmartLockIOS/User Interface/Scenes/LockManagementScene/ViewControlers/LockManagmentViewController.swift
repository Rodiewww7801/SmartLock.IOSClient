//
//  LockManagmentViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation
import UIKit

class LockManagmentViewController: UIViewController {
    private var lockViewCell: LockViewCell!
    private var buttonStackView: UIStackView!
    private var lockHistoriesButton: UIButton!
    private var userAccessesButton: UIButton!
    private var deleteButton: UIButton!
    private let viewModel: LockManagmentViewModel
    private let loadingScreen = FDLoadingScreen()
    
    var onGetUserLockAccessesAction: ((_ lockId: String)->Void)?
    var onGetHistroriesAction: ((_ lockId: String) -> Void)?
    var onDeleteAction: (()->Void)?
    
    init(with viewModel: LockManagmentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        viewModel.getCurrentUser { [weak self] user in
            DispatchQueue.main.async {
                self?.deleteButton.isHidden = user.role != .admin
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }
    
    private func loadData() {
        self.loadingScreen.show(on: self.view)
        self.viewModel.loadData { [weak self] lock in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.lockViewCell.updateData(lock)
                self.loadingScreen.stop()
            }
        }
    }
    
    private func configureViews() {
        self.view.backgroundColor = .white
        configureLockView()
        configureButtonStackView()
        configureManagmentStackView()
    }
    
    private func configureLockView() {
        lockViewCell = LockViewCell()
        lockViewCell.configure()
        lockViewCell.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(lockViewCell)
        lockViewCell.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        lockViewCell.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        lockViewCell.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func configureButtonStackView() {
        buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.contentMode = .left
        buttonStackView.spacing = 0
        
        self.view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.topAnchor.constraint(equalTo: lockViewCell.bottomAnchor, constant: 20).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
    }
    
    
    private func configureManagmentStackView() {
        addDividerIn(buttonStackView)
        
        userAccessesButton = UIButton(type: .system)
        userAccessesButton.backgroundColor = .white
        userAccessesButton.contentHorizontalAlignment = .left
        userAccessesButton.setTitle("User accesses", for: .normal)
        userAccessesButton.setTitleColor(.systemGray, for: .normal)
        userAccessesButton.addTarget(self, action: #selector(onGetUserLockAccessesTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(userAccessesButton)
        userAccessesButton.translatesAutoresizingMaskIntoConstraints = false
        userAccessesButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userAccessesButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        addDividerIn(buttonStackView)
        
        lockHistoriesButton = UIButton(type: .system)
        lockHistoriesButton.backgroundColor = .white
        lockHistoriesButton.contentHorizontalAlignment = .left
        lockHistoriesButton.setTitle("Histories", for: .normal)
        lockHistoriesButton.setTitleColor(.systemGray, for: .normal)
        lockHistoriesButton.addTarget(self, action: #selector(onHistoriesTapped), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(lockHistoriesButton)
        lockHistoriesButton.translatesAutoresizingMaskIntoConstraints = false
        lockHistoriesButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        lockHistoriesButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        addDividerIn(buttonStackView)
        
        deleteButton = UIButton(type: .system)
        deleteButton.backgroundColor = .white
        deleteButton.contentHorizontalAlignment = .left
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteLock), for: .touchUpInside)
        deleteButton.isHidden = true
       
        buttonStackView.addArrangedSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.widthAnchor.constraint(equalTo: buttonStackView.widthAnchor).isActive = true
        
        addDividerIn(buttonStackView)
    }
    
    private func addDividerIn(_ stackView: UIStackView) {
        let divider = UIView()
        divider.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        stackView.addArrangedSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    @objc private func deleteLock() {
        func startDelete() {
            loadingScreen.show(on: self.view)
            viewModel.deleteLock { isSuccess in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    loadingScreen.stop()
                    if isSuccess {
                        FDAlert()
                            .createWith(title: "Lock was deleted", message: nil)
                            .addAction(title: "Ok", style: .default, handler: {
                                self.onDeleteAction?()
                            })
                            .present(on: self)
                    }
                }
            }
        }
        
        guard let lockName = viewModel.lock?.name else { return }
        FDAlert()
            .createWith(title: "Are you sure you want to delete \(lockName)?", message: nil)
            .addAction(title: "Cancel", style: .cancel, handler: nil)
            .addAction(title: "Yes", style: .default, handler: {
                startDelete()
            })
            .present(on: self)
    }
    
    @objc private func onHistoriesTapped() {
        self.onGetHistroriesAction?(self.viewModel.lockId)
    }
    
    @objc private func onGetUserLockAccessesTapped()  {
        self.onGetUserLockAccessesAction?(self.viewModel.lockId)
    }
}
