//
//  UserInfoViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

class UserInfoViewController: UIViewController {
    private var userInfoView: UserInfoViewCell!
    private var viewModel: UserInfoViewModel
    private var buttonStackView: UIStackView!
    private var updateUserButton: UIButton!
    private var loadingScreen = FDLoadingScreen()
    
    var onUpdateUserAction: ((UserInfo)->Void)?
    
    init(with viewModel: UserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadModel()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .white
        configureUserInfoView()
        configureButtonStackView()
        configureManagmentStackView()
    }
    
    private func loadModel() {
        loadingScreen.show(on: self.view)
        viewModel.configure { [weak self] model in
            DispatchQueue.main.async {
                self?.userInfoView.updateData(model)
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
                self?.loadingScreen.stop()
            }
        }
    }
    
    private func configureUserInfoView() {
        userInfoView = UserInfoViewCell()
        userInfoView.configure()
        self.view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    private func configureButtonStackView() {
        buttonStackView = UIStackView()
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 0
        
        self.view.addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 20).isActive = true
        buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 25).isActive = true
        buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
    }
    
    private func configureManagmentStackView() {
        addDividerIn(buttonStackView)
        
        updateUserButton = UIButton(type: .system)
        updateUserButton.backgroundColor = .white
        updateUserButton.setTitle("Edit", for: .normal)
        updateUserButton.setTitleColor(.systemBlue, for: .normal)
        updateUserButton.addTarget(self, action: #selector(updateUser), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(updateUserButton)
        updateUserButton.translatesAutoresizingMaskIntoConstraints = false
        updateUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func addDividerIn(_ stackView: UIStackView) {
        let divider = UIView()
        divider.layer.backgroundColor = UIColor.systemGray6.cgColor
        
        stackView.addArrangedSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    @objc private func updateUser() {
        guard let userInfo = viewModel.userInfoModel else { return }
        self.onUpdateUserAction?(userInfo)
    }
    
}
