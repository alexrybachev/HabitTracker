//
//  TabBarController.swift
//  HabitTracker
//
//  Created by Aleksandr Rybachev on 23.11.2023.
//

import UIKit

class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewController()
  }
  
  private func setupViewController() {
    tabBar.backgroundColor = .yaWhite
    tabBar.tintColor = .yaBlue
    tabBar.barTintColor = .yaGray
    
    tabBar.layer.shadowColor = UIColor.black.cgColor
    tabBar.layer.shadowOpacity = 0.3
    tabBar.layer.shadowOffset = CGSize(width: 0, height: -0.5)
    tabBar.layer.shadowRadius = 0
    
    let trackersVC = TrackersViewController()
    trackersVC.tabBarItem = UITabBarItem(
      title: "Трекеры",
      image: UIImage(named: "trackerImage"),
      selectedImage: nil
    )
    
    let statisticVC = StatisticViewController()
    statisticVC.tabBarItem = UITabBarItem(
      title: "Статистика",
      image: UIImage(named: "statisticImage"),
      selectedImage: nil
    )
    
    viewControllers = [trackersVC, statisticVC]
  }
  
}
