//
//  Weak.swift
//  Smart Lock
//
//  Created by Rodion Hladchenko on 15.08.2023.
//

import Foundation

class Weak<T: AnyObject> {
  weak var value : T?
  init (value: T) {
    self.value = value
  }
}
