//
//  Tracker.swift
//  HabitTracker
//
//  Created by Aleksandr Rybachev on 24.11.2023.
//

import Foundation

/// Сущность для хранения информации про трекер (для «Привычки» или «Нерегулярного события»)
struct Tracker {
    let id = UUID()
    let name: String
    let color: String
    let emoji: String
    let schedule: String
}

// TODO: - Структуру данных для хранения расписания выберите на своё усмотрение.
#warning("Структуру данных для хранения расписания выберите на своё усмотрение.")
