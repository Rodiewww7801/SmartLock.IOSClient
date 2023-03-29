//
//  DebugView.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 29.03.2023.
//

import UIKit

class DebugView: UIView {
    private var rectView: UIView = UIView()
    private var ellipseView: UIView = UIView()
    private var debugLabel: UILabel = UILabel()
    private var debugAcceptableRollLabel: UILabel = UILabel()
    private var debugAcceptablePitchLabel: UILabel = UILabel()
    private var debugAcceptableYawLabel: UILabel = UILabel()
    private var debugAcceptableQualityLabel: UILabel = UILabel()
    private var debugLabelsStack: UIStackView = UIStackView()
    private var faceLayoutGuideFrame: CGRect {
        let screenSize: CGRect = UIScreen.main.bounds
        return CGRect(x: 0, y: 0, width: ( screenSize.height * 0.4) / 1.5, height: screenSize.height * 0.4)
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
       
    }
    
    private func configureViews() {
        addRect()
        cofigureDebugLabels()
    }
    
    private func addRect() {
        self.rectView = UIView(frame: faceLayoutGuideFrame)
        rectView.layer.borderColor = UIColor.red.cgColor
        rectView.layer.borderWidth = 1.0
        rectView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rectView)
        rectView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        rectView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
        rectView.heightAnchor.constraint(equalToConstant: self.faceLayoutGuideFrame.height).isActive = true
        rectView.widthAnchor.constraint(equalToConstant: self.faceLayoutGuideFrame.width).isActive = true
        
        addEllipse()
    }
    
    private func addEllipse() {
        self.ellipseView = UIView(frame: faceLayoutGuideFrame)
        let scaledEllipseSize = CGSize(width: faceLayoutGuideFrame.width - 1, height: faceLayoutGuideFrame.height - 1)
        let ellipsePath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: scaledEllipseSize))
        let ellipseLayer = CAShapeLayer()
        ellipseLayer.path = ellipsePath.cgPath
        ellipseLayer.strokeColor = UIColor.red.cgColor
        ellipseLayer.fillColor = UIColor.clear.cgColor
        ellipseLayer.position = CGPoint(x: (rectView.bounds.width - 1) / -2 , y: (rectView.bounds.height - 1) / -2)
        ellipseView.layer.addSublayer(ellipseLayer)
        
        ellipseView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ellipseView)
        ellipseView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ellipseView.centerYAnchor.constraint(equalTo: rectView.centerYAnchor).isActive = true
    }
    
    private func cofigureDebugLabels() {
        configureDebugLabelsText()
        
        debugLabelsStack.distribution = .fillEqually
        debugLabelsStack.axis = .vertical
        debugLabelsStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(debugLabelsStack)
        debugLabelsStack.bottomAnchor.constraint(equalTo: self.rectView.topAnchor, constant: -5).isActive = true
        debugLabelsStack.leadingAnchor.constraint(equalTo: self.rectView.leadingAnchor).isActive = true
        
        debugLabelsStack.addArrangedSubview(debugLabel)
        debugLabelsStack.addArrangedSubview(debugAcceptableRollLabel)
        debugLabelsStack.addArrangedSubview(debugAcceptablePitchLabel)
        debugLabelsStack.addArrangedSubview(debugAcceptableYawLabel)
        debugLabelsStack.addArrangedSubview(debugAcceptableQualityLabel)
    }
    
    private func configureDebugLabelsText() {
        debugLabel.text = "Debug:"
        debugLabel.textColor = .white
        debugLabel.font = .systemFont(ofSize: 12)
        
        debugAcceptableRollLabel.text = "Roll:\(0)"
        debugAcceptableRollLabel.textColor = .red
        debugAcceptableRollLabel.font = .systemFont(ofSize: 12)
        
        debugAcceptablePitchLabel.text = "Pitch:\(0)"
        debugAcceptablePitchLabel.textColor = .red
        debugAcceptablePitchLabel.font = .systemFont(ofSize: 12)
        
        debugAcceptableYawLabel.text = "Yaw:\(0)"
        debugAcceptableYawLabel.textColor = .red
        debugAcceptableYawLabel.font = .systemFont(ofSize: 12)
        
        debugAcceptableQualityLabel.text = "Quality:\(0)"
        debugAcceptableQualityLabel.textColor = .red
        debugAcceptableQualityLabel.font = .systemFont(ofSize: 12)
    }
}
