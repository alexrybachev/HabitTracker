//
//  StatisticViewController.swift
//  HabitTracker
//
//  Created by Aleksandr Rybachev on 23.11.2023.
//

import UIKit

class StatisticViewController: UIViewController {
  
  // MARK: - Elements
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = "Статистика"
    titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
    titleLabel.textColor = .yaBlack
    return titleLabel
  }()
  
  private let statisticPlaceholder = UIStackView()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setViews()
    setConstraints()
  }
}

// MARK: - Layout & Setting
extension StatisticViewController {
  private func setViews() {
    view.backgroundColor = .yaWhite
    view.addSubview(titleLabel)
    view.addSubview(statisticPlaceholder)
    statisticPlaceholder.configure(name: "cryPlaceholder", text: "Анализировать пока нечего")
  }
  
  private func setConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      statisticPlaceholder.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      statisticPlaceholder.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }
}
