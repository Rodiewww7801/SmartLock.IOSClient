//
//  PhotoListViewCell.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 18.08.2023.
//

import UIKit

class PhotoListViewCell: UITableViewCell {
    private var topImageView: UIImageView!
    private var idLableTitle: UILabel!
    private var idLableText: UILabel!
    private var deleteButton: UIButton!
    private var model: Photo?
    
    var onDeleteAction: ((String, Int) -> ())?
    
    func configure(_ model: Photo) {
        self.contentView.removeFromSuperview()
        self.selectionStyle = .none
        self.model = model
        configureTopImageView(model)
        configureLabels(model)
        configureDeleteButton()
    }
    
    private func configureTopImageView(_ model: Photo) {
        topImageView = UIImageView(image: model.image)
        topImageView.tintColor = .systemGray5
        topImageView.contentMode = .scaleAspectFit
        topImageView.clipsToBounds = true
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
    
    private func configureLabels(_ model: Photo) {
        idLableTitle = UILabel(frame: .zero)
        idLableTitle.text = "Id"
        idLableTitle.font = UIFont.preferredFont(forTextStyle: .body)
        idLableTitle.numberOfLines = 0
        idLableTitle.textColor = .gray
        idLableTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(idLableTitle)
        
        idLableText = UILabel(frame: .zero)
        idLableText.text = String(model.info.id)
        idLableText.font = UIFont.preferredFont(forTextStyle: .body)
        idLableText.numberOfLines = 0
        idLableText.textColor = .black
        idLableText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(idLableText)
        
        idLableTitle.topAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: 10).isActive = true
        idLableTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        idLableTitle.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true

        idLableText.topAnchor.constraint(equalTo: idLableTitle.bottomAnchor, constant: 10).isActive = true
        idLableText.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        idLableText.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20).isActive = true
    }
    
    private func configureDeleteButton() {
        deleteButton = UIButton(type: .system)
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.addTarget(self, action: #selector(onDelete), for: .touchUpInside)
        
        self.addSubview(deleteButton)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        deleteButton.topAnchor.constraint(equalTo: idLableText.bottomAnchor, constant: 10).isActive = true
        deleteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc private func onDelete() {
        guard let model = self.model else { return }
        onDeleteAction?(model.info.userId, model.info.id)
    }
}
