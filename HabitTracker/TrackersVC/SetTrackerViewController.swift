//
//  SetTrackerViewController.swift
//  HabitTracker
//
//  Created by Леонид Турко on 26.12.2023.
//

import UIKit

protocol SetTrackerViewControllerDelegate: AnyObject {
  func didCancelButtonTapped()
  func didCreateButtonTapped(category: String, tracker: Tracker)
}

final class SetTrackerViewController: UIViewController {
  // MARK: - UI Elements
  private lazy var nameTracker: UITextField = {
      let element = TextFieldSetting(placeholder: "Введите название трекера")
      element.addTarget(self, action: #selector(didChangeTextOnNameTracker), for: .editingChanged)
      return element
  }()
  
  private lazy var limitMessage: UILabel = {
      let element = UILabel()
      element.translatesAutoresizingMaskIntoConstraints = false
      element.font = UIFont.systemFont(ofSize: 17, weight: .regular)
      element.textColor = .yaRed
      element.text = "Ограничение 38 символов"
      return element
  }()
  
  private lazy var optionsTableView: UITableView = {
      let element = UITableView()
      element.translatesAutoresizingMaskIntoConstraints = false
      element.separatorStyle = .none
      element.isScrollEnabled = false
      element.register(SettingTableCell.self, forCellReuseIdentifier: SettingTableCell.identifier)
      return element
  }()
  
  private lazy var cancelButton: UIButton = {
      let element = UIButton()
      element.translatesAutoresizingMaskIntoConstraints = false
      element.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
      element.layer.cornerRadius = 16
      element.layer.masksToBounds = true
      element.setTitle("Отменить", for: .normal)
      element.setTitleColor(.yaRed, for: .normal)
      element.backgroundColor = .yaWhite
      element.layer.borderWidth = 1
      element.layer.borderColor = UIColor.yaRed.cgColor
      element.addTarget(self, action: #selector(didCancelButtonTapped), for: .touchUpInside)
      return element
  }()
  
  private lazy var createButton: UIButton = {
      let element = UIButton()
      element.translatesAutoresizingMaskIntoConstraints = false
      element.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
      element.layer.cornerRadius = 16
      element.layer.masksToBounds = true
      element.setTitle("Создать", for: .normal)
      element.setTitleColor(.white, for: .normal)
      element.backgroundColor = .yaGray
      element.addTarget(self, action: #selector(didCreateButtonTapped), for: .touchUpInside)
      element.isEnabled = false
      return element
  }()
  
  private let buttonStack: UIStackView = {
      let element = UIStackView()
      element.translatesAutoresizingMaskIntoConstraints = false
      element.spacing = 8
      element.axis = .horizontal
      element.distribution = .fillEqually
      return element
  }()
  
  // MARK: - Properties
  weak var delegate: SetTrackerViewControllerDelegate?
  private let version: CreateTrackerViewController.TrackerVersion
  private var data: Tracker.Track {
    didSet {
      checkButtonValidation()
    }
  }
  
  private var buttonIsEnable = false {
    willSet {
      if newValue {
        createButton.backgroundColor = .yaBlack 
        createButton.setTitleColor(.yaWhite, for: .normal)
        createButton.isEnabled = true
      } else {
        createButton.backgroundColor = .yaGray
        createButton.setTitleColor(.white, for: .normal)
        createButton.isEnabled = false
      }
    }
  }
  
  private var limitMessageVisible = false {
    didSet {
      checkButtonValidation()
      if limitMessageVisible {
        messageHeightConstraint?.constant = 22
        optionsTopConstraint?.constant = 32
      } else {
        messageHeightConstraint?.constant = 0
        optionsTopConstraint?.constant = 16
      }
    }
  }
  
  private var scheduleString: String? {
    guard let schedule = data.schedule else { return nil }
    if schedule.count == 7 { return "Каждый день" }
    let short: [String] = schedule.map { $0.shortcut }
    return short.joined(separator: ", ")
  }
  
  private var category: String? = TrackerCategory.defaultValue[0].title {
    didSet {
      checkButtonValidation()
    }
  }
  
  private var messageHeightConstraint: NSLayoutConstraint?
  private var optionsTopConstraint: NSLayoutConstraint?
  private let trackerColors = UIColor.trackerColors
  private let parameters = ["Категория", "Расписание"]
  private let emoji = [
      "🙂", "😻", "🌺", "🐶", "❤️", "😱",
      "😇", "😡", "🥶", "🤔", "🙌", "🍔",
      "🥦", "🏓", "🥇", "🎸", "🏝", "😪",
  ]
  
  // MARK: - Initializers
  init(version: CreateTrackerViewController.TrackerVersion, data: Tracker.Track = Tracker.Track()) {
    self.version = version
    self.data = data
    super.init(nibName: nil, bundle: nil)
    
    switch version {
    case .habit:
      self.data.schedule = []
    case .event:
      self.data.schedule = nil
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setViews()
    setConstraints()
    setDelegates()
    setTitle()
  }
}

// MARK: - Layout & Setting
extension SetTrackerViewController {
  private func setViews() {
    view.backgroundColor = .yaWhite
    view.addSubviews([nameTracker, limitMessage, optionsTableView, buttonStack])
    buttonStack.addArrangedSubview(cancelButton)
    buttonStack.addArrangedSubview(createButton)
    checkButtonValidation()
    takeRandomElement()
  }
  
  private func setConstraints() {
    messageHeightConstraint = limitMessage.heightAnchor.constraint(equalToConstant: 0)
    messageHeightConstraint?.isActive = true
    optionsTopConstraint = optionsTableView.topAnchor.constraint(equalTo: limitMessage.bottomAnchor, constant: 16)
    optionsTopConstraint?.isActive = true
    
    NSLayoutConstraint.activate([
      nameTracker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      nameTracker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      nameTracker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      nameTracker.heightAnchor.constraint(equalToConstant: 75),
      limitMessage.centerXAnchor.constraint(equalTo: nameTracker.centerXAnchor),
      limitMessage.topAnchor.constraint(equalTo: nameTracker.bottomAnchor, constant: 8),
      optionsTableView.heightAnchor.constraint(equalToConstant: title == "Новая привычка" ? 150 : 75),
      optionsTableView.leadingAnchor.constraint(equalTo: nameTracker.leadingAnchor),
      optionsTableView.trailingAnchor.constraint(equalTo: nameTracker.trailingAnchor),
      buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
      buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
      buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      buttonStack.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  private func setDelegates() {
    nameTracker.delegate = self
    optionsTableView.dataSource = self
    optionsTableView.delegate = self
  }
}

// MARK: - Privat methods
extension SetTrackerViewController {
  private func checkButtonValidation() {
    if data.name.count == 0 {
      buttonIsEnable = false
      return
    }
    
    if limitMessageVisible {
      buttonIsEnable = false
      return
    }
    
    if category == nil {
      buttonIsEnable = false
      return
    }
    
    if let schedule = data.schedule, schedule.isEmpty {
      buttonIsEnable = false
      return
    }
    buttonIsEnable = true
  }
  
  private func takeRandomElement() {
    data.emoji = emoji.randomElement()
    data.color = trackerColors.randomElement()
  }
  
  private func setTitle() {
    switch version {
    case .habit:
      title = "Новая привычка"
    case .event:
      title = "Новое нерегулярное событие"
    }
  }
}

// MARK: - OBJC Methods
extension SetTrackerViewController {
  @objc private func didChangeTextOnNameTracker(_ sender: UITextField) {
    guard let text = sender.text else { return }
    data.name = text
    
    if text.count > 38 {
      limitMessageVisible = true
    } else {
      limitMessageVisible = false
    }
  }
  
  @objc private func didCancelButtonTapped() {
    delegate?.didCancelButtonTapped()
  }
  
  @objc private func didCreateButtonTapped() {
    guard let category = category,
          let emoji = data.emoji,
          let color = data.color else { return }
    let createNewTracker = Tracker(name: data.name, color: color, emoji: emoji, schedule: data.schedule)
    delegate?.didCreateButtonTapped(category: category, tracker: createNewTracker)
  }
}

// MARK: - UITableViewDataSource
extension SetTrackerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data.schedule == nil ? 1 : 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableCell.identifier, for: indexPath) as? SettingTableCell else { return UITableViewCell() }
    
    var description: String? = nil
    var position: CellBackgroundSetting.Position
    
    if data.schedule == nil {
      description = category
      position = .common
    } else {
      description = indexPath.row == 0 ? category : scheduleString
      position = indexPath.row == 0 ? .top : .bottom
    }
    
    cell.configure(name: parameters[indexPath.row], description: description, position: position)
    return cell
  }
}

// MARK: - UITableViewDelegate
extension SetTrackerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row != 0 {
      guard let schedule = data.schedule else { return }
      let scheduleViewController = ScheduleViewController(markedWeekdays: schedule)
      scheduleViewController.delegate = self
      let navigationController = UINavigationController(rootViewController: scheduleViewController)
      present(navigationController, animated: true)
    } else {
      return
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    75
  }
}

// MARK: - ScheduleViewControllerDelegate
extension SetTrackerViewController: ScheduleViewControllerDelegate {
  func didRdy(activeDays: [WeekDays]) {
    data.schedule = activeDays
    optionsTableView.reloadData()
    dismiss(animated: true)
  }
}

// MARK: - UITextFieldDelegate
extension SetTrackerViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    nameTracker.resignFirstResponder()
    return true
  }
}
