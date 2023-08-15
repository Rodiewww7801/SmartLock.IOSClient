//
//  FDLoaderScreen.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import UIKit

class FDLoadingScreen: UIView {
    private var actitvityIndicator: UIActivityIndicatorView!
    
    init() {
        super.init(frame: .zero)
        self.configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        
        configureActivivityIndicator()
    }
    
    private func configureActivivityIndicator() {
        actitvityIndicator = UIActivityIndicatorView()
        actitvityIndicator.style = .medium
        actitvityIndicator.color = .systemBlue
        
        addSubview(actitvityIndicator)
        actitvityIndicator.translatesAutoresizingMaskIntoConstraints = false
        actitvityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        actitvityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func show(on view: UIView) {
        removeFromSuperview()
        view.addSubview(self)
        self.alpha = 0
        actitvityIndicator.alpha = 0
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.alpha = 1
            self?.actitvityIndicator.alpha = 1
            self?.actitvityIndicator.startAnimating()
        })
    }
    
    func stop() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.5, animations: {
                self?.actitvityIndicator.alpha = 0
                self?.alpha = 0
            }, completion: { _ in
                self?.actitvityIndicator.stopAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.removeFromSuperview()
                }
            })
        }
    }
}
