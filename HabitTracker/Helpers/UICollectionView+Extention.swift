//
//  UICollectionView+Extention.swift
//  HabitTracker
//
//  Created by Леонид Турко on 25.12.2023.
//

import UIKit

extension UICollectionView {
  struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
      self.cellCount = cellCount
      self.leftInset = leftInset
      self.rightInset = rightInset
      self.cellSpacing = cellSpacing
      self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
  }
}
