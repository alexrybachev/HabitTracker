//
//  TrackerCell.swift
//  HabitTracker
//
//  Created by Леонид Турко on 25.12.2023.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
  func didCompletedButtonTapped(cell: TrackerCell, with tracker: Tracker)
}

class TrackerCell: UICollectionViewCell {
  // MARK: - Identifier
  static let reuseIdentifier = String(describing: TrackerCell.self)
  
  private lazy var cardView: UIView = {
    let element = UIView()
    element.layer.borderWidth = 1
    element.layer.cornerRadius = 16
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var emojiView: UIView = {
    let element = UIView()
    element.layer.cornerRadius = 12
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var emojiLabel: UILabel = {
    let element = UILabel()
    element.font = .systemFont(ofSize: 16)
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var trackerLabel: UILabel = {
    let element = UILabel()
    element.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    element.textColor = .white
    element.numberOfLines = 0
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var daysLabel: UILabel = {
    let element = UILabel()
    element.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var completedButton: UIButton = {
    let element = UIButton()
    element.setImage(UIImage(systemName: "plus"), for: .normal)
    element.layer.cornerRadius = 17
    element.addTarget(self, action: #selector(didCompletedButtonTapped), for: .touchUpInside)
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  // MARK: - Properties
  weak var delegate: TrackerCellDelegate?
  private var tracker: Tracker?
  private var daysCount = 0 {
    willSet {
      daysLabel.text = newValue.daysString()
    }
  }
  
// MARK: - Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    setViews()
    setConstraints()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    tracker = nil
    daysCount = 0
    completedButton.setImage(UIImage(systemName: "plus"), for: .normal)
    completedButton.layer.opacity = 1
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with tracker: Tracker, days: Int, active: Bool) {
    self.tracker = tracker
    self.daysCount = days
    emojiLabel.text = tracker.emoji
    trackerLabel.text = tracker.name
    cardView.backgroundColor = tracker.color
    completedButton.backgroundColor = tracker.color
    changeCompletedImageButton(active: active)
  }
}

extension TrackerCell {
  // MARK: - Private methods
  func changeCompletedImageButton(active: Bool) {
    if active {
      completedButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
      completedButton.layer.opacity = 0.3
    } else {
      completedButton.setImage(UIImage(systemName: "plus"), for: .normal)
      completedButton.layer.opacity = 1
    }
  }
  
  func addOrReduce(value: Bool) {
    if value == true {
      daysCount += 1
    } else {
      daysCount -= 1
    }
  }
  
  @objc private func didCompletedButtonTapped() {
    guard let tracker else { return }
    delegate?.didCompletedButtonTapped(cell: self, with: tracker)
  }
}

extension TrackerCell {
  private func setViews() {
    addSubviews([cardView, emojiView, emojiLabel, trackerLabel, daysLabel, completedButton])
  }
  
  private func setConstraints() {
    NSLayoutConstraint.activate([
      cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
      cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      cardView.heightAnchor.constraint(equalToConstant: 90),
      emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
      emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
      emojiView.widthAnchor.constraint(equalToConstant: 24),
      emojiView.heightAnchor.constraint(equalToConstant: 24),
      emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
      emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
      trackerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
      trackerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
      trackerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 12),
      daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
      daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
      completedButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
      completedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
      completedButton.widthAnchor.constraint(equalToConstant: 34),
      completedButton.heightAnchor.constraint(equalToConstant: 34)
    ])
  }
}
