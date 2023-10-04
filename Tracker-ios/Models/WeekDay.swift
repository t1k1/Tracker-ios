//
//  WeekDay.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 04.10.2023.
//

import Foundation

enum WeekDay: CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var dayName: String {
        switch self {
            case .monday:
                return "Понедельник"
            case .tuesday:
                return "Вторник"
            case .wednesday:
                return "Среда"
            case .thursday:
                return "Четверг"
            case .friday:
                return "Пятница"
            case .saturday:
                return "Суббота"
            case .sunday:
                return "Воскресенье"
        }
       
    }
    var shortDayName: String {
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
}
