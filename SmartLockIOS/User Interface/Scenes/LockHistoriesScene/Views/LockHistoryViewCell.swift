//
//  LockHistoryViewCell.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 24.08.2023.
//

import Foundation

import Foundation
import UIKit

class LockHistoryViewCell: UITableViewCell {
    private var topImageView: UIImageView!
    private var lockIdLableTitle: UILabel!
    private var lockIdLableText: UILabel!
    private var nameLableTitle: UILabel!
    private var nameLableText: UILabel!
    private var timeLabelTitle: UILabel!
    private var timeLabelText: UILabel!
    private var deleteButton: UIButton!
    private var model: LockHistory?
    
    func configure() {
        self.contentView.removeFromSuperview()
        self.selectionStyle = .none
        configureTopImageView()
        configureLabels()
    }
    
    func updateData(_ model: LockHistory) {
        self.model = model
        nameLableText.text = model.lock.name
        lockIdLableText.text = model.user.id
        timeLabelText.text = "\(model.openedDataTime)"
    }
    
    private func configureTopImageView() {
        let image = UIImage(systemName: "lock")
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
        lockIdLableTitle = UILabel(frame: .zero)
        lockIdLableTitle.text = "Id"
        lockIdLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        lockIdLableTitle.numberOfLines = 0
        lockIdLableTitle.textColor = .gray
        lockIdLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lockIdLableTitle)
        
        nameLableTitle = UILabel(frame: .zero)
        nameLableTitle.text = "Name"
        nameLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        nameLableTitle.numberOfLines = 0
        nameLableTitle.textColor = .gray
        nameLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLableTitle)
        
        timeLabelTitle = UILabel(frame: .zero)
        timeLabelTitle.text = "Time"
        timeLabelTitle.font = UIFont.preferredFont(forTextStyle: .body)
        timeLabelTitle.numberOfLines = 0
        timeLabelTitle.textColor = .gray
        timeLabelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLabelTitle)
        
        lockIdLableText = UILabel(frame: .zero)
        lockIdLableText.font = UIFont.preferredFont(forTextStyle: .body)
        lockIdLableText.numberOfLines = 0
        lockIdLableText.textColor = .black
        lockIdLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lockIdLableText)
        
        nameLableText = UILabel(frame: .zero)
        nameLableText.font = UIFont.preferredFont(forTextStyle: .body)
        nameLableText.numberOfLines = 0
        nameLableText.textColor = .black
        nameLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLableText)
        
        timeLabelText = UILabel(frame: .zero)
        timeLabelText.font = UIFont.preferredFont(forTextStyle: .body)
        timeLabelText.numberOfLines = 0
        timeLabelText.textColor = .black
        timeLabelText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLabelText)
        
        lockIdLableTitle.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10).isActive = true
        lockIdLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lockIdLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        lockIdLableText.topAnchor.constraint(equalTo: lockIdLableTitle.bottomAnchor, constant: 10).isActive = true
        lockIdLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lockIdLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        nameLableTitle.topAnchor.constraint(equalTo: lockIdLableText.bottomAnchor, constant: 10).isActive = true
        nameLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        nameLableText.topAnchor.constraint(equalTo: nameLableTitle.bottomAnchor, constant: 10).isActive = true
        nameLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        
        timeLabelTitle.topAnchor.constraint(equalTo: nameLableText.bottomAnchor, constant: 10).isActive = true
        timeLabelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        timeLabelTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        
        timeLabelText.topAnchor.constraint(equalTo: timeLabelTitle.bottomAnchor, constant: 10).isActive = true
        timeLabelText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        timeLabelText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        timeLabelText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
}
