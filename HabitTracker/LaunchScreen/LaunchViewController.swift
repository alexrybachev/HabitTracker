//
//  LaunchViewController.swift
//  HabitTracker
//
//  Created by Леонид Турко on 24.11.2023.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    // MARK: - UIElements
    private lazy var image: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "Vector")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
        delay()
    }
    
    deinit {
        #warning("Не происходит деинит LaunchViewController")
        print("deinit LaunchViewController")
    }
}

// MARK: - Private methods
extension LaunchViewController {
    
    // MARK: - Setup Views
    private func setViews() {
        view.backgroundColor = #colorLiteral(red: 0.2145571113, green: 0.4462329149, blue: 0.9076376557, alpha: 1)
        view.addSubview(image)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func delay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showTabBarController()
        }
    }
    
    private func showTabBarController() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
    
}
