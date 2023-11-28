//
//  FilterModel.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 28.11.2023.
//

import Foundation

enum Filter: String, CaseIterable {
    case allTrackers = "Все трекеры"
    case todayTrackers = "Трекеры на сегодня"
    case completedTrackers = "Завершенные"
    case uncompletedTrackers = "Незавершенные"
}
