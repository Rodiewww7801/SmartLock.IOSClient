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
    private var loadingScreen = FDLoadingScreen()
    
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
        loadModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureViews() {
        //self.view.backgroundColor = .white
        configureUserInfoView()
    }
    
    private func loadModel() {
        loadingScreen.show(on: self.view)
        viewModel.configure { [weak self] model in
            DispatchQueue.main.async {
                self?.userInfoView.configure(model)
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
                self?.loadingScreen.stop()
            }
        }
    }
    
    private func configureUserInfoView() {
        userInfoView = UserInfoViewCell()
        self.view.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
}
