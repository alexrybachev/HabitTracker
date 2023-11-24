//
//  TrackerRecord.swift
//  HabitTracker
//
//  Created by Aleksandr Rybachev on 24.11.2023.
//

import Foundation

/// Сущность для хранения записи о том, что некий трекер был выполнен на некоторую дату
struct TrackerRecord {
    let id: UUID
    let date: Date
}
