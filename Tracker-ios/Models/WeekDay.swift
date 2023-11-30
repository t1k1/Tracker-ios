//
//  WeekDay.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 04.10.2023.
//

import Foundation

enum WeekDay: CaseIterable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    var dayName: String {
        switch self {
            case .monday:
                return NSLocalizedString("monday", tableName: "LocalizableStr", comment: "")
            case .tuesday:
                return NSLocalizedString("tuesday", tableName: "LocalizableStr", comment: "")
            case .wednesday:
                return NSLocalizedString("wednesday", tableName: "LocalizableStr", comment: "")
            case .thursday:
                return NSLocalizedString("thursday", tableName: "LocalizableStr", comment: "")
            case .friday:
                return NSLocalizedString("friday", tableName: "LocalizableStr", comment: "")
            case .saturday:
                return NSLocalizedString("saturday", tableName: "LocalizableStr", comment: "")
            case .sunday:
                return NSLocalizedString("sunday", tableName: "LocalizableStr", comment: "")
        }
       
    }
    var shortDayName: String {
        switch self {
            case .monday:
                return NSLocalizedString("mon", tableName: "LocalizableStr", comment: "")
            case .tuesday:
                return NSLocalizedString("tue", tableName: "LocalizableStr", comment: "")
            case .wednesday:
                return NSLocalizedString("wed", tableName: "LocalizableStr", comment: "")
            case .thursday:
                return NSLocalizedString("thu", tableName: "LocalizableStr", comment: "")
            case .friday:
                return NSLocalizedString("fri", tableName: "LocalizableStr", comment: "")
            case .saturday:
                return NSLocalizedString("sat", tableName: "LocalizableStr", comment: "")
            case .sunday:
                return NSLocalizedString("sun", tableName: "LocalizableStr", comment: "")
        }
    }
    var numberOfDay: Int {
        switch self {
            case .monday:
                return 2
            case .tuesday:
                return 3
            case .wednesday:
                return 4
            case .thursday:
                return 5
            case .friday:
                return 6
            case .saturday:
                return 7
            case .sunday:
                return 1
        }
    }
}
