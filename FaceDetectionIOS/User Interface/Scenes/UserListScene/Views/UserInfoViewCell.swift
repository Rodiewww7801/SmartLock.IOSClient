//
//  UserViewCell.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 17.08.2023.
//

import UIKit

class UserInfoViewCell: UITableViewCell {
    static let reuseIdentifier: String = "UserInfoViewCellrReuseIdentifier"
    private var userInfoView: UserInfoView!
    private var model: UserInfoModel?
    
    func configureViews(_ user: User) {
        contentView.backgroundColor = .white
        self.model = UserInfoModel(user: user)
        configureUserInfoView()
        updateView()
    }
    
    private func updateView() {
        userInfoView.model = model
        userInfoView.updateLabels()
    }
    
    private func configureUserInfoView() {
        self.userInfoView = UserInfoView()
        self.contentView.addSubview(userInfoView)
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        userInfoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        userInfoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        userInfoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
}
