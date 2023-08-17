//
//  UserInfoView.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 16.08.2023.
//

import UIKit

class UserInfoView: UIView {
    var model: UserInfo?
    private var userInfoStackView: UIStackView!
    private var userImageView: UIImageView!
    private var userIdLabel: UITextView!
    private var usernameLabel: UITextView!
    private var emailLabel: UITextView!
    private var firstNameLabel: UITextView!
    private var lastNameLabel: UITextView!
    private var roleLabel: UITextView!
    
    init() {
        super.init(frame: .zero)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.backgroundColor = .white
        
        configureUserAvatar()
        configureUserInfoStack()
        configureUserInfoLabels()
    }
    
    private func configureUserAvatar() {
        let userImage = UIImage(systemName: "person.fill")
        userImageView = UIImageView(image: userImage)
        userImageView.tintColor = .black
        //userImageView.contentMode = .scaleAspectFit
        
        self.addSubview(userImageView)
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configureUserInfoStack() {
        userInfoStackView = UIStackView()
        userInfoStackView.axis = .vertical
        userInfoStackView.spacing = 0
        
        self.addSubview(userInfoStackView)
        userInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        userInfoStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10).isActive = true
        userInfoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        userInfoStackView.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
    }
    
    private func configureUserInfoLabels() {
        var labels = [UITextView]()
        
        userIdLabel = UITextView()
        usernameLabel = UITextView()
        emailLabel = UITextView()
        firstNameLabel = UITextView()
        lastNameLabel = UITextView()
        roleLabel = UITextView()
        
        labels.append(contentsOf: [ userIdLabel, usernameLabel, emailLabel, firstNameLabel, lastNameLabel, roleLabel])
        
        labels.forEach { label in
            userInfoStackView.addArrangedSubview(label)
            label.font = .systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalTo: userInfoStackView.widthAnchor).isActive = true
            label.isScrollEnabled = false
        }
    }
    
    func updateLabels() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let model = model else { return }

            userIdLabel.text = "Id: \(model.user.id)"

            usernameLabel.text = "Username: \(model.user.username)"

            emailLabel.text = "Email: \(model.user.email)"

            firstNameLabel.text = "First name: \(model.user.firstName)"

            lastNameLabel.text = "Last name: \(model.user.lastName)"

            roleLabel.text = "Role: \(model.user.role.rawValue)"
            
            let stackHeight = userInfoStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            self.heightAnchor.constraint(equalToConstant: stackHeight + 10).isActive = true
        }
    }
}
