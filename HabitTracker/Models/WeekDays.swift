//
//  WeekDays.swift
//  HabitTracker
//
//  Created by Леонид Турко on 25.12.2023.
//

import Foundation

enum WeekDays: String, CaseIterable, Comparable {
  case monday = "Понедельник"
  case tuesday = "Вторник"
  case wednesday = "Среда"
  case thursday = "Четверг"
  case friday = "Пятница"
  case saturday = "Суббота"
  case sunday = "Воскресенье"
  
  var shortcut: String {
    switch self {
    case .monday:
      return "Пн"
    case .tuesday:
      return "Вт"
    case .wednesday:
      return "Ср"
    case .thursday:
      return "Чт"
    case .friday:
      return "Пт"
    case .saturday:
      return "Сб"
    case .sunday:
      return "Вс"
    }
  }
  
  static func < (lhs: WeekDays, rhs: WeekDays) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
