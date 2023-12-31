//
//  Tracker.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 02.10.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let pinned: Bool
    let shedule: [WeekDay]
}
