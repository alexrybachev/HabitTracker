//
//  TrackersViewController.swift
//  HabitTracker
//
//  Created by Aleksandr Rybachev on 23.11.2023.
//

import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: - UIElements
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    

    // MARK: - Setup Views
    
    private func setupViews() {
        title = "Трекеры"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addBarButtonTapped)
        )
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    // MARK: - OBJC Methods
    
    @objc private func addBarButtonTapped() {
        print("TrackersVC - " + #function)
    }

}
