//
//  Tracker.swift
//  HabitTracker
//
//  Created by Леонид Турко on 19.12.2023.
//

import UIKit

struct Tracker {
  let id: UUID
  let name: String
  let color: UIColor
  let emoji: String
  let schedule: [WeekDays]?
  
  init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, schedule: [WeekDays]?) {
    self.id = id
    self.name = name
    self.color = color
    self.emoji = emoji
    self.schedule = schedule
  }
}

extension Tracker {
  struct Track {
    var name: String = ""
    var color: UIColor? = nil
    var emoji: String? = ""
    var schedule: [WeekDays]? = nil 
  }
}
