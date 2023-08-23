//
//  LockViewCell.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 21.08.2023.
//

import UIKit

class LockViewCell: UITableViewCell {
    private var topImageView: UIImageView!
    private var lockIdLableTitle: UILabel!
    private var lockIdLableText: UILabel!
    private var lockNameLableTitle: UILabel!
    private var lockNameLableText: UILabel!
    private var lockDescriptionLableTitle: UILabel!
    private var lockDescriptionLableText: UILabel!
    
    func configure() {
        configureTopImageView()
        configureLabels()
    }
    
    func updateData(_ model: Lock) {
        lockNameLableText.text = model.name
        lockIdLableText.text = model.id
        lockDescriptionLableText.text = model.description
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
        
        lockNameLableTitle = UILabel(frame: .zero)
        lockNameLableTitle.text = "Lock name"
        lockNameLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        lockNameLableTitle.numberOfLines = 0
        lockNameLableTitle.textColor = .gray
        lockNameLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lockNameLableTitle)
        
        lockDescriptionLableTitle = UILabel(frame: .zero)
        lockDescriptionLableTitle.text = "Lock description"
        lockDescriptionLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        lockDescriptionLableTitle.numberOfLines = 0
        lockDescriptionLableTitle.textColor = .gray
        lockDescriptionLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lockDescriptionLableTitle)
        
        lockIdLableText = UILabel(frame: .zero)
        lockIdLableText.font = UIFont.preferredFont(forTextStyle: .body)
        lockIdLableText.numberOfLines = 0
        lockIdLableText.textColor = .black
        lockIdLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lockIdLableText)
        
        lockNameLableText = UILabel(frame: .zero)
        lockNameLableText.font = UIFont.preferredFont(forTextStyle: .body)
        lockNameLableText.numberOfLines = 0
        lockNameLableText.textColor = .black
        lockNameLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lockNameLableText)
        
        lockDescriptionLableText = UILabel(frame: .zero)
        lockDescriptionLableText.font = UIFont.preferredFont(forTextStyle: .body)
        lockDescriptionLableText.numberOfLines = 0
        lockDescriptionLableText.textColor = .black
        lockDescriptionLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lockDescriptionLableText)
        
        lockIdLableTitle.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10).isActive = true
        lockIdLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lockIdLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        lockIdLableText.topAnchor.constraint(equalTo: lockIdLableTitle.bottomAnchor, constant: 10).isActive = true
        lockIdLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lockIdLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        lockNameLableTitle.topAnchor.constraint(equalTo: lockIdLableText.bottomAnchor, constant: 10).isActive = true
        lockNameLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lockNameLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        lockNameLableText.topAnchor.constraint(equalTo: lockNameLableTitle.bottomAnchor, constant: 10).isActive = true
        lockNameLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lockNameLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        lockDescriptionLableTitle.topAnchor.constraint(equalTo: lockNameLableText.bottomAnchor, constant: 10).isActive = true
        lockDescriptionLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lockDescriptionLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        lockDescriptionLableText.topAnchor.constraint(equalTo: lockDescriptionLableTitle.bottomAnchor, constant: 10).isActive = true
        lockDescriptionLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        lockDescriptionLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
        lockDescriptionLableText.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
    }
}
