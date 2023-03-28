//
//  FDFadeAnimatedButton.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 28.03.2023.
//

import UIKit

class FDFadeAnimatedButton: UIControl {
    let customView: UIView
    private(set) var customAction: (()->())?
    
    init(with customView: UIView) {
        self.customView = customView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureControl() {
        configureView()
    }
    
    private func configureView() {
        customView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(customView)
        customView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.isUserInteractionEnabled = true
        
    }
    
    func addAction(_ action: @escaping ()->(), for event: UIControl.Event = .allEvents ) {
        self.customAction = action
        self.addTarget(self, action: #selector(executeCustomAction), for: event)
    }
    
    @objc private func executeCustomAction() {
        self.customAction?()
    }
}

extension FDFadeAnimatedButton {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.transition(with: self, duration: 0.1, animations: {
            self.backgroundColor = UIColor.systemGray4.withAlphaComponent(1)
        })
        super.touchesBegan(touches, with: event)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.transition(with: self, duration: 0.4, animations: {
            self.backgroundColor = UIColor.clear
        })
        super.touchesEnded(touches, with: event)
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.transition(with: self, duration: 0.4, animations: {
            self.backgroundColor = UIColor.clear
        })
        super.touchesCancelled(touches, with: event)
    }
}
