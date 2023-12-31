//
//  TrackersViewController.swift
//  HabitTracker
//
//  Created by Aleksandr Rybachev on 23.11.2023.
//

import UIKit

class TrackersViewController: UIViewController {
  
  // MARK: - UI Elements
  private lazy var addButton: UIButton = {
    let element = UIButton(type: .system)
    element.setImage(UIImage(systemName: "plus"), for: .normal)
    element.tintColor = .black
    element.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    element.frame = CGRect(x: 0, y: 0, width: 42, height: 42)
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var datePicker: UIDatePicker = {
    let element = UIDatePicker()
    
    element.preferredDatePickerStyle = .compact
    element.datePickerMode = .date
    element.locale = Locale(identifier: "ru_Ru")
    element.calendar = Calendar(identifier: .iso8601)
    
    element.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let element = UICollectionView(frame: .zero, collectionViewLayout: layout)
    element.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
    element.register(TrackerCategoryHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var filterButton: UIButton = {
    let element = UIButton()
    element.tintColor = .white
    element.setTitle("Фильтры", for: .normal)
    element.layer.cornerRadius = 16
    element.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
    element.translatesAutoresizingMaskIntoConstraints = false
    return element
  }()
  
  private lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = "Трекеры"
    titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
    return titleLabel
  }()
  
  private lazy var searchField: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    searchBar.placeholder = "Поиск"
    return searchBar
  }()
  
  // MARK: - Properties
  private var categories: [TrackerCategory] = TrackerCategory.defaultValue
  private var completedTrackers: Set<TrackerRecord> = []
  private var completedButtonIsEnable = true
  private let defaultPlaceholder = UIStackView()
  private let searchPlaceholder = UIStackView()
  private var currentDate = Date()
  private var searchText = ""
  private let geometricParams = UICollectionView.GeometricParams(
    cellCount: 2,
    leftInset: 16,
    rightInset: 16,
    cellSpacing: 9
  )
  
  private var currentTrakers: [TrackerCategory] {
    let day = Calendar.current.component(.weekday, from: currentDate)
    var trackers = [TrackerCategory]()
    for category in categories {
      let trackersFilter = category.trackers.filter { tracker in
        guard let schedule = tracker.schedule else { return true }
        return schedule.contains(WeekDays.allCases[day > 1 ? day - 2: day + 5])
      }
      if searchText.isEmpty && !trackersFilter.isEmpty {
        trackers.append(TrackerCategory(title: category.title, trackers: trackersFilter))
      } else {
        let filter = trackersFilter.filter {
          $0.name.localizedCaseInsensitiveContains(searchText)
        }
        if !filter.isEmpty {
          trackers.append(TrackerCategory(title: category.title, trackers: filter))
        }
      }
    }
    
    if trackers.isEmpty {
      filterButton.isHidden = true
    } else {
      filterButton.isHidden = false
    }
    return trackers
  }
  
  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    setDelegates()
    checkPlaceholder()
  }
  
  
  // MARK: - Setup Views
  
  private func setupViews() {
    view.backgroundColor = .yaWhite
    defaultPlaceholder.configure(name: "starPlaceholder", text: "Что будем отслеживать?")
    searchPlaceholder.configure(name: "monoclePlaceholder", text: "Ничего не найдено")
    view.addSubviews([titleLabel, addButton, searchField, datePicker, collectionView, defaultPlaceholder, searchPlaceholder, filterButton])
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      addButton.heightAnchor.constraint(equalToConstant: 44),
      addButton.widthAnchor.constraint(equalToConstant: 44),
      addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
      addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
      titleLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 0),
      titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
      searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
      searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      datePicker.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
      datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      datePicker.widthAnchor.constraint(equalToConstant: 120),
      collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
      collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      defaultPlaceholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      defaultPlaceholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      searchPlaceholder.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      searchPlaceholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
      filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
      filterButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
      filterButton.heightAnchor.constraint(equalToConstant: 50),
      filterButton.widthAnchor.constraint(equalToConstant: 114)
    ])
  }
  
  private func setDelegates() {
    collectionView.dataSource = self
    collectionView.delegate = self
    searchField.delegate = self
  }
  
  private func checkPlaceholder() {
    placeHolderCheckForEmpty()
    placeHolderCheckForSearch()
  }
  
  // MARK: - OBJC Methods
  @objc private func addButtonTapped() {
    let createTrack = CreateTrackerViewController()
    createTrack.delegate = self
    let navigationController = UINavigationController(rootViewController: createTrack)
    present(navigationController, animated: true)
  }
  
  @objc func datePickerValueChanged(_ sender: UIDatePicker) {
    currentDate = sender.date
    completedButtonIsEnable = isDatePass(currentDate)
    collectionView.reloadData()
  }
  
  // MARK: - Private methods
  private func isDatePass(_ date: Date) -> Bool {
    date <= Date()
  }
  
  private func placeHolderCheckForEmpty() {
    let isHidden = currentTrakers.isEmpty && searchPlaceholder.isHidden
    defaultPlaceholder.isHidden = !isHidden
  }
  
  private func placeHolderCheckForSearch() {
    let isHidden = currentTrakers.isEmpty && searchField.text != ""
    searchPlaceholder.isHidden = isHidden
  }
}
  
// MARK: - TrackerCellDelegate
extension TrackersViewController: TrackerCellDelegate {
  func didCompletedButtonTapped(cell: TrackerCell, with tracker: Tracker) {
    if completedButtonIsEnable == true {
      let recordTracker = TrackerRecord(id: tracker.id, date: currentDate)
      if let index = completedTrackers.firstIndex(where: { $0.date == currentDate && $0.id == tracker.id }) {
        completedTrackers.remove(at: index)
        cell.changeCompletedImageButton(active: false)
        cell.addOrReduce(value: false)
      } else {
        completedTrackers.insert(recordTracker)
        cell.changeCompletedImageButton(active: true)
        cell.addOrReduce(value: true)
      }
    } else {
      let date = Date()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd.MM.yyyy"
      let todayFormDate = dateFormatter.string(from: date)
      let selectedDate = dateFormatter.string(from: currentDate)
      let alert = UIAlertController(
        title: "Сегодня - \(todayFormDate)г.",
        message: "Нельзя выполнить данное действие - \(selectedDate)г., т.к. данный период времени еще не наступил!",
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "Понятно", style: .default))
      present(alert, animated: true)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    placeHolderCheckForSearch()
    return currentTrakers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    currentTrakers[section].trackers.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as? TrackerCell else { return UICollectionViewCell() }
    
    let tracker = currentTrakers[indexPath.section].trackers[indexPath.item]
    let daysCount = completedTrackers.filter { $0.id  == tracker.id }.count
    let active = completedTrackers.contains { $0.date == currentDate && $0.id == tracker.id }
    cell.configure(with: tracker, days: daysCount, active: active)
    cell.delegate = self
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 16, left: geometricParams.leftInset, bottom: 16, right: geometricParams.rightInset)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let availableSpace = collectionView.frame.width - geometricParams.paddingWidth
    let cellWidth = availableSpace / CGFloat(geometricParams.cellCount)
    return CGSize(width: cellWidth, height: 148)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    geometricParams.cellSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard
      kind == UICollectionView.elementKindSectionHeader,
      let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerCategoryHeader else { return UICollectionReusableView() }
    let label = currentTrakers[indexPath.section].title
    cell.configure(text: label)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let indexPath = IndexPath(item: 0, section: section)
    let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
    
    return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
  }
}

// MARK: - CreateTrackerViewControllerDelegate
extension TrackersViewController: CreateTrackerViewControllerDelegate {
  func didCreateTracker(with version: CreateTrackerViewController.TrackerVersion) {
    dismiss(animated: true)
    let settingTracker = SetTrackerViewController(version: version)
    settingTracker.delegate = self
    let navigationController = UINavigationController(rootViewController: settingTracker)
    present(navigationController, animated: true)
  }
}

// MARK: - SetTrackerViewControllerDelegate
extension TrackersViewController: SetTrackerViewControllerDelegate {
  func didCancelButtonTapped() {
    dismiss(animated: true)
  }
  
  func didCreateButtonTapped(category: String, tracker: Tracker) {
    dismiss(animated: true)
    guard let categoryIndex = categories.firstIndex(where: { $0.title == category }) else { return }
    let newCardForCategory = TrackerCategory(title: category, trackers: categories[categoryIndex].trackers + [tracker])
    
    categories[categoryIndex] = newCardForCategory
    collectionView.reloadData()
  }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchText = searchText
    collectionView.reloadData()
    placeHolderCheckForSearch()
  }
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    placeHolderCheckForSearch()
    searchBar.setShowsCancelButton(true, animated: true)
    return true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.endEditing(true)
    searchBar.setShowsCancelButton(false, animated: true)
    self.searchText = ""
    collectionView.reloadData()
    placeHolderCheckForSearch()
  }
}
