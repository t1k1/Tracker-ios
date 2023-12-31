//
//  TrackerStoreUpdate.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 24.11.2023.
//

import Foundation

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}
