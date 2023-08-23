//
//  UserAccessesViewCell.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 23.08.2023.
//

import Foundation
import UIKit

class UserAccessesViewCell: UITableViewCell {
    private var topImageView: UIImageView!
    private var userIdLableTitle: UILabel!
    private var userIdLableText: UILabel!
    private var nameLableTitle: UILabel!
    private var nameLableText: UILabel!
    private var hasAccessLableTitle: UILabel!
    private var hasAccessLableText: UILabel!
    private var deleteButton: UIButton!
    private var model: UserLockAccess?
    
    var onDeleteAction: ((String, String)->())?
    
    func configure() {
        self.contentView.removeFromSuperview()
        self.selectionStyle = .none
        configureTopImageView()
        configureLabels()
        configureDeleteButton()
    }
    
    func updateData(_ model: UserLockAccess) {
        self.model = model
        nameLableText.text = model.user.firstName + " " + model.user.lastName
        userIdLableText.text = model.user.id
        if let photo = model.user.face {
            topImageView.image = photo
        } else {
            topImageView.image = UIImage(systemName: "person.fill")
        }
        if model.hasAccess  {
            self.hasAccessLableText.text = "Has access"
            self.hasAccessLableText.textColor = .green
        } else {
            self.hasAccessLableText.text = "Was canceled"
            self.hasAccessLableText.textColor = .red
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
        
        nameLableTitle = UILabel(frame: .zero)
        nameLableTitle.text = "Name"
        nameLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        nameLableTitle.numberOfLines = 0
        nameLableTitle.textColor = .gray
        nameLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLableTitle)
        
        hasAccessLableTitle = UILabel(frame: .zero)
        hasAccessLableTitle.text = "Access"
        hasAccessLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        hasAccessLableTitle.numberOfLines = 0
        hasAccessLableTitle.textColor = .gray
        hasAccessLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(hasAccessLableTitle)
        
        userIdLableText = UILabel(frame: .zero)
        userIdLableText.font = UIFont.preferredFont(forTextStyle: .body)
        userIdLableText.numberOfLines = 0
        userIdLableText.textColor = .black
        userIdLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userIdLableText)
        
        nameLableText = UILabel(frame: .zero)
        nameLableText.font = UIFont.preferredFont(forTextStyle: .body)
        nameLableText.numberOfLines = 0
        nameLableText.textColor = .black
        nameLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLableText)
        
        hasAccessLableText = UILabel(frame: .zero)
        hasAccessLableText.font = UIFont.preferredFont(forTextStyle: .body)
        hasAccessLableText.numberOfLines = 0
        hasAccessLableText.textColor = .black
        hasAccessLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(hasAccessLableText)
        
        userIdLableTitle.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10).isActive = true
        userIdLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        userIdLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        userIdLableText.topAnchor.constraint(equalTo: userIdLableTitle.bottomAnchor, constant: 10).isActive = true
        userIdLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        userIdLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        nameLableTitle.topAnchor.constraint(equalTo: userIdLableText.bottomAnchor, constant: 10).isActive = true
        nameLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        nameLableText.topAnchor.constraint(equalTo: nameLableTitle.bottomAnchor, constant: 10).isActive = true
        nameLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        
        hasAccessLableTitle.topAnchor.constraint(equalTo: nameLableText.bottomAnchor, constant: 10).isActive = true
        hasAccessLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        hasAccessLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        
        hasAccessLableText.topAnchor.constraint(equalTo: hasAccessLableTitle.bottomAnchor, constant: 10).isActive = true
        hasAccessLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        hasAccessLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
    }
    
    private func configureDeleteButton() {
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        
        self.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.topAnchor.constraint(equalTo: hasAccessLableText.bottomAnchor, constant: 10).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc private func onDelete() {
        guard let model = model else { return }
        self.onDeleteAction?(model.lock.id, model.user.id)
    }
}
