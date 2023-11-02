//
//  Date+Extensions.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 01.11.2023.
//

import Foundation

extension Date {
    var ignoringTime: Date? {
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        return Calendar.current.date(from: dateComponents)
    }
}
