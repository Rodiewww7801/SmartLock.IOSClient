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
    private var ellipseLayer: CAShapeLayer?
    private var debugLabel: UILabel = UILabel()
    private var debugAcceptableRollLabel: UILabel = UILabel()
    private var debugAcceptablePitchLabel: UILabel = UILabel()
    private var debugAcceptableYawLabel: UILabel = UILabel()
    private var debugAcceptableQualityLabel: UILabel = UILabel()
    private var debugLabelsStack: UIStackView = UIStackView()
    private var faceLayoutGuideFrame: CGRect {
        return viewModel.faceLayoutGuideFrame
    }
    
    var viewModel: DetectionSceneViewModel
    
    init(with viewModel: DetectionSceneViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.backgroundColor = .clear
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        switch viewModel.faceGemetryState {
        case .faceFound(let model):
            drawFaceRect(model.boundingBox)
            configureDebugLabelsText(faceGemetryModel: model)
            updateState()
        case .faceNotFound:
            clearFaceRect()
            break
        case .errored(_):
            clearFaceRect()
            break
        }
    }
    
    func drawFaceRect(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
          return
        }

        context.saveGState()
        defer {
          context.restoreGState()
        }
        context.addRect(rect)
        UIColor.yellow.setStroke()
        context.strokePath()
    }
    
    public func clearFaceRect() {
        drawFaceRect(.zero)
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
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
        rectView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        rectView.heightAnchor.constraint(equalToConstant: self.faceLayoutGuideFrame.height).isActive = true
        rectView.widthAnchor.constraint(equalToConstant: self.faceLayoutGuideFrame.width).isActive = true
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
    
    private func configureDebugLabelsText(faceGemetryModel: FaceGeometryModel? = nil) {
        guard let faceGemetryModel = faceGemetryModel else { return }
        let isAcceptableRoll = viewModel.isAcceptableRoll
        let isAcceptablePitch = viewModel.isAcceptablePitch
        let isAcceptableYaw = viewModel.isAcceptableYaw
        let isAcceptableQuality = viewModel.isAcceptableQuality
        
        debugLabel.text = "Debug:"
        debugLabel.textColor = .white
        debugLabel.font = .systemFont(ofSize: 12)
        
        debugAcceptableRollLabel.text = "Roll:\(faceGemetryModel.roll)"
        debugAcceptableRollLabel.textColor = isAcceptableRoll ? .green : .red
        debugAcceptableRollLabel.font = .systemFont(ofSize: 12)
        
        debugAcceptablePitchLabel.text = "Pitch:\(faceGemetryModel.pitch)"
        debugAcceptablePitchLabel.textColor =  isAcceptablePitch ? .green : .red
        debugAcceptablePitchLabel.font = .systemFont(ofSize: 12)
        
        debugAcceptableYawLabel.text = "Yaw:\(faceGemetryModel.yaw)"
        debugAcceptableYawLabel.textColor =  isAcceptableYaw ? .green : .red
        debugAcceptableYawLabel.font = .systemFont(ofSize: 12)
        
        debugAcceptableQualityLabel.text = "Quality:\(faceGemetryModel.quality)"
        debugAcceptableQualityLabel.textColor =  isAcceptableQuality ? .green : .red
        debugAcceptableQualityLabel.font = .systemFont(ofSize: 12)
    }
    
    private func updateState() {
        if viewModel.faceValidationState {
            ellipseLayer?.strokeColor = UIColor.green.cgColor
            rectView.layer.borderColor = UIColor.green.cgColor
        } else {
            ellipseLayer?.strokeColor = UIColor.red.cgColor
            rectView.layer.borderColor = UIColor.red.cgColor
        }
    }
}
