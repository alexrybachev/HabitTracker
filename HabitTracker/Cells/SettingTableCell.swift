//
//  SettingTableCell.swift
//  HabitTracker
//
//  Created by Леонид Турко on 26.12.2023.
//

import UIKit

final class SettingTableCell: UITableViewCell {
  // MARK: - Identifier
  static let identifier = String(describing: SettingTableCell.self)
  
  // MARK: - UI Elements
  private lazy var cellView = CellBackgroundSetting()
  
  private lazy var nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .yaBlack
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .yaGray
    label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    return label
  }()
  
  private lazy var button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(named: "arrowRight"), for: .normal)
    button.isEnabled = false
    return button
  }()
  
  private let labelStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.spacing = 2
    stack.axis = .vertical
    return stack
  }()
  
  // MARK: - Initializers
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setViews()
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(name: String, description: String?, position: CellBackgroundSetting.Position) {
    nameLabel.text = name
    cellView.configure(position: position)
    
    if let description {
      descriptionLabel.text = description
    }
  }
}

// MARK: - Layout & Setting
private extension SettingTableCell {
  func setViews() {
    contentView.addSubviews([cellView, labelStack, button])
    labelStack.addArrangedSubview(nameLabel)
    labelStack.addArrangedSubview(descriptionLabel)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      labelStack.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
      labelStack.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
      labelStack.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -56),
      button.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
      button.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16)
    ])
  }
}
