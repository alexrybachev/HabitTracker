//
//  TrackerCategoryHeader.swift
//  HabitTracker
//
//  Created by Леонид Турко on 25.12.2023.
//

import UIKit

final class TrackerCategoryHeader: UICollectionReusableView {
  // MARK: - UI Elements
  private lazy var categoryLabel: UILabel = {
    let element = UILabel()
    element.font = .systemFont(ofSize: 19, weight: .bold)
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setViews()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(text: String) {
    categoryLabel.text = text
  }
}

extension TrackerCategoryHeader {
  // MARK: - Private Methods
  private func setViews() {
    addSubview(categoryLabel)
  }
  
  private func setConstraints() {
    NSLayoutConstraint.activate([
      categoryLabel.topAnchor.constraint(equalTo: topAnchor),
      categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
      categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
    ])
  }
}
