//
//  UserInfoViewCell.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import UIKit

class UserInfoViewCell: UITableViewCell {
    private var topImageView: UIImageView!
    private var userIdLableTitle: UILabel!
    private var userIdLableText: UILabel!
    private var usernameLableTitle: UILabel!
    private var usernameLableText: UILabel!
    private var emailLableTitle: UILabel!
    private var emailLableText: UILabel!
    private var firstNameLabelTitle: UILabel!
    private var firstNameLabelText: UILabel!
    private var lastNameLabelTitle: UILabel!
    private var lastNameLabelText: UILabel!
    private var roleLabelTitle: UILabel!
    private var roleLabelText: UILabel!
    
    func configure() {
        configureTopImageView()
        configureLabels()
    }
    
    func updateData(_ model: User) {
        usernameLableText.text = model.username
        userIdLableText.text = model.id
        emailLableText.text = model.email
        firstNameLabelText.text = model.firstName
        lastNameLabelText.text =  model.lastName
        roleLabelText.text = model.role.rawValue
        if let photo = model.face {
            topImageView.image = photo
        } else {
            topImageView.image = UIImage(systemName: "person.fill")
        }
    }
    
    private func configureTopImageView() {
        let image = UIImage(systemName: "person.fill")
        topImageView = UIImageView(image: image)
        topImageView.tintColor = .systemGray5
        topImageView.contentMode = .scaleAspectFit
        topImageView.layer.borderWidth = 1
        topImageView.backgroundColor = .white
        topImageView.layer.borderColor = UIColor.systemGray5.cgColor
        
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topImageView)
        topImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        topImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        topImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        topImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func configureLabels() {
        userIdLableTitle = UILabel(frame: .zero)
        userIdLableTitle.text = "Id"
        userIdLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        userIdLableTitle.numberOfLines = 0
        userIdLableTitle.textColor = .gray
        userIdLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userIdLableTitle)
        
        usernameLableTitle = UILabel(frame: .zero)
        usernameLableTitle.text = "Username"
        usernameLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        usernameLableTitle.numberOfLines = 0
        usernameLableTitle.textColor = .gray
        usernameLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usernameLableTitle)
        
        emailLableTitle = UILabel(frame: .zero)
        emailLableTitle.text = "Email"
        emailLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        emailLableTitle.numberOfLines = 0
        emailLableTitle.textColor = .gray
        emailLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailLableTitle)
        
        firstNameLabelTitle = UILabel(frame: .zero)
        firstNameLabelTitle.text = "First name"
        firstNameLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        firstNameLabelTitle.numberOfLines = 0
        firstNameLabelTitle.textColor = .gray
        firstNameLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(firstNameLabelTitle)
        
        lastNameLabelTitle = UILabel(frame: .zero)
        lastNameLabelTitle.text = "Last name"
        lastNameLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        lastNameLabelTitle.numberOfLines = 0
        lastNameLabelTitle.textColor = .gray
        lastNameLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lastNameLabelTitle)
        
        roleLabelTitle = UILabel(frame: .zero)
        roleLabelTitle.text = "Role"
        roleLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        roleLabelTitle.numberOfLines = 0
        roleLabelTitle.textColor = .gray
        roleLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(roleLabelTitle)
        
        userIdLableText = UILabel(frame: .zero)
        userIdLableText.font = UIFont.preferredFont(forTextStyle: .body)
        userIdLableText.numberOfLines = 0
        userIdLableText.textColor = .black
        userIdLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userIdLableText)
        
        usernameLableText = UILabel(frame: .zero)
        usernameLableText.font = UIFont.preferredFont(forTextStyle: .body)
        usernameLableText.numberOfLines = 0
        usernameLableText.textColor = .black
        usernameLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(usernameLableText)
        
        emailLableText = UILabel(frame: .zero)
        emailLableText.font = UIFont.preferredFont(forTextStyle: .body)
        emailLableText.numberOfLines = 0
        emailLableText.textColor = .black
        emailLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailLableText)
        
        firstNameLabelText = UILabel(frame: .zero)
        firstNameLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        firstNameLabelText.numberOfLines = 0
        firstNameLabelText.textColor = .black
        firstNameLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(firstNameLabelText)
        
        lastNameLabelText = UILabel(frame: .zero)
        lastNameLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        lastNameLabelText.numberOfLines = 0
        lastNameLabelText.textColor = .black
        lastNameLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lastNameLabelText)
        
        roleLabelText = UILabel(frame: .zero)
        roleLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        roleLabelText.numberOfLines = 0
        roleLabelText.textColor = .black
        roleLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(roleLabelText)
        
        userIdLableTitle.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10).isActive = true
        userIdLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        userIdLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        userIdLableText.topAnchor.constraint(equalTo: userIdLableTitle.bottomAnchor, constant: 10).isActive = true
        userIdLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        userIdLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        usernameLableTitle.topAnchor.constraint(equalTo: userIdLableText.bottomAnchor, constant: 10).isActive = true
        usernameLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        usernameLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        usernameLableText.topAnchor.constraint(equalTo: usernameLableTitle.bottomAnchor, constant: 10).isActive = true
        usernameLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        usernameLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        emailLableTitle.topAnchor.constraint(equalTo: usernameLableText.bottomAnchor, constant: 10).isActive = true
        emailLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        emailLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        emailLableText.topAnchor.constraint(equalTo: emailLableTitle.bottomAnchor, constant: 10).isActive = true
        emailLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        emailLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
            
        firstNameLabelTitle.topAnchor.constraint(equalTo: emailLableText.bottomAnchor, constant: 10).isActive = true
        firstNameLabelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        firstNameLabelTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        firstNameLabelText.topAnchor.constraint(equalTo: firstNameLabelTitle.bottomAnchor, constant: 10).isActive = true
        firstNameLabelText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        firstNameLabelText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        lastNameLabelTitle.topAnchor.constraint(equalTo: firstNameLabelText.bottomAnchor, constant: 10).isActive = true
        lastNameLabelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lastNameLabelTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        lastNameLabelText.topAnchor.constraint(equalTo: lastNameLabelTitle.bottomAnchor, constant: 10).isActive = true
        lastNameLabelText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lastNameLabelText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        roleLabelTitle.topAnchor.constraint(equalTo: lastNameLabelText.bottomAnchor, constant: 10).isActive = true
        roleLabelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        roleLabelTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        roleLabelText.topAnchor.constraint(equalTo: roleLabelTitle.bottomAnchor, constant: 10).isActive = true
        roleLabelText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        roleLabelText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        roleLabelText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
}
