//
//  FDAlert.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 03.04.2023.
//

import Foundation
import UIKit

class FDAlert {
    var alert: UIAlertController = UIAlertController()
    
    @discardableResult
    func createWith(title: String, message: String? = nil) -> FDAlert {
        self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return self
    }
    
    @discardableResult
    func addAction(title: String?, style: UIAlertAction.Style, handler: (()->Void)?) -> FDAlert {
        self.alert.addAction(UIAlertAction(title: title, style: style, handler: { _ in
            handler?()
        }))
        return self
    }
    
    @discardableResult
    func present(on router: Router?) -> FDAlert {
        DispatchQueue.main.async {
            router?.present(self.alert, animated: true)
        }
        return self
    }
    
    @discardableResult
    func present(on presentedViewController: Presentable?) -> FDAlert {
        DispatchQueue.main.async { 
            presentedViewController?.toPresent().present(self.alert, animated: true, completion: nil)
        }
        return self
    }
}

extension FDAlert: Presentable{
    func toPresent() -> UIViewController {
        return alert
    }
}
