//
//  UIView+Extention.swift
//  HabitTracker
//
//  Created by Леонид Турко on 25.12.2023.
//

import UIKit

extension UIView {
  func addSubviews(_ subviews: [UIView]) {
    subviews.forEach { addSubview($0) }
  }
}
