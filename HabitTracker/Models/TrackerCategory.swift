//
//  TrackerCategory.swift
//  HabitTracker
//
//  Created by Леонид Турко on 19.12.2023.
//

import Foundation

struct TrackerCategory {
  let title: String
  let trackers: [Tracker]
}

extension TrackerCategory {
  static let defaultValue: [TrackerCategory] = [TrackerCategory(title: "Основное", trackers: [])]
}


