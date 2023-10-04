//
//  GestureController.swift
//  FaceDetectionIOS
//
//  Created by Rodion Hladchenko on 25.05.2023.
//

import Foundation
import UIKit

protocol GestureController: AnyObject {
    func pinchGestureHandler(gesture: UIPinchGestureRecognizer)
    func panGestureHandler(gesture: UIPanGestureRecognizer)
}
