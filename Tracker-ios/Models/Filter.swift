//
//  FilterModel.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 28.11.2023.
//

import Foundation

enum Filter: String, CaseIterable {
    case allTrackers, todayTrackers, completedTrackers, uncompletedTrackers
    
    var localizedString: String {
        switch self {
            case .allTrackers:
                return NSLocalizedString("allTrackers", tableName: "LocalizableStr", comment: "")
            case .todayTrackers:
                return NSLocalizedString("todayTrackers", tableName: "LocalizableStr", comment: "")
            case .completedTrackers:
                return NSLocalizedString("Completed", tableName: "LocalizableStr", comment: "")
            case .uncompletedTrackers:
                return NSLocalizedString("Uncompleted", tableName: "LocalizableStr", comment: "")
        }
    }
}
