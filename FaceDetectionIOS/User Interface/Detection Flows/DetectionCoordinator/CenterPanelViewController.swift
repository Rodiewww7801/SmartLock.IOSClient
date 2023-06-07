//
//  CenterPanelViewController.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 27.05.2023.
//

import Foundation
import UIKit

class CenterPanelViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("[CenterPanelViewController]: init")
    }
    
    deinit {
        print("[CenterPanelViewController]: deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
    }
}

class LeftPanelViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("[LeftPanelViewController]: init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[LeftPanelViewController]: deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}

class RightPanelViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("[RightPanelViewController]: init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("[RightPanelViewController]: deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
}
