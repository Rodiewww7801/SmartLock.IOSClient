//
//  UserInfoViewController.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

class UserInfoViewController: UIViewController {
    private var userInfoView: UserInfoView!
    private var viewModel: UserInfoViewModel
    private var loadingScreen = FDLoadingScreen()
    
    init(with viewModel: UserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureModel()
    }
    
    private func configureViews() {
        self.view.backgroundColor = .white
        configureUserInfoView()
    }
    
    private func configureUserInfoView() {
        userInfoView = UserInfoView()
        self.view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    private func configureModel() {
        loadingScreen.show(on: self.view)
        viewModel.configure { [weak self] model in
            DispatchQueue.main.async {
                self?.userInfoView.model = model
                self?.userInfoView.updateLabels()
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
                self?.loadingScreen.stop()
            }
        }
    }
}
