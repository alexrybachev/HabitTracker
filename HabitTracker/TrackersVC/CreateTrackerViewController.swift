//
//  CreateTrackerViewController.swift
//  HabitTracker
//
//  Created by Леонид Турко on 26.12.2023.
//

import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
  func didCreateTracker(with: CreateTrackerViewController.TrackerVersion)
}

final class CreateTrackerViewController: UIViewController {
  // MARK: - UI Elements
  private lazy var habitButton: UIButton = {
    let element = UIButton()
    element.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    element.setTitle("Привычка", for: .normal)
    element.setTitleColor(.yaWhite, for: .normal)
    element.backgroundColor = .yaBlack
    element.layer.cornerRadius = 16
    element.addTarget(self, action: #selector(didHabitButtonTapped), for: .touchUpInside)
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var irregularEventButton: UIButton = {
    let element = UIButton()
    element.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    element.setTitle("Нерегулярное событие", for: .normal)
    element.layer.cornerRadius = 16
    element.addTarget(self, action: #selector(didIrregularButtonTapped), for: .touchUpInside)
    element.setTitleColor(.yaWhite, for: .normal)
    element.backgroundColor = .yaBlack
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var buttonsStack: UIStackView = {
    let element = UIStackView()
    element.spacing = 16
    element.axis = .vertical
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  // MARK: - Properties
  weak var delegate: CreateTrackerViewControllerDelegate?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setViews()
    setConstraints()
  }
  
  enum TrackerVersion {
    case habit, event
  }
}

// MARK: - Private Methods
extension CreateTrackerViewController {
  private func setViews() {
    title = "Создание трекера"
    view.backgroundColor = .yaWhite
    view.addSubview(buttonsStack)
    buttonsStack.addArrangedSubview(habitButton)
    buttonsStack.addArrangedSubview(irregularEventButton)
  }
  
  private func setConstraints() {
    NSLayoutConstraint.activate([
      habitButton.heightAnchor.constraint(equalToConstant: 60),
      irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
      buttonsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
    ])
  }
}

// MARK: - OBJC Methods
extension CreateTrackerViewController {
  @objc func didHabitButtonTapped() {
    title = "Новая привычка"
    delegate?.didCreateTracker(with: .habit)
  }
  
  @objc func didIrregularButtonTapped() {
    title = "Новое нерегулярное событие"
    delegate?.didCreateTracker(with: .event)
  }
}
