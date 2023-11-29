//
//  Tracker_ios_Tests.swift
//  Tracker-ios_Tests
//
//  Created by Aleksey Kolesnikov on 28.11.2023.
//

import XCTest
import SnapshotTesting
@testable import Tracker_ios

final class Tracker_ios_Tests: XCTestCase {
    func testTrackerViewControllerLight() {
        let viewController = TrackerViewController()
        assertSnapshot(matching: viewController.view, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testTrackerViewControllerDark() {
        let viewController = TrackerViewController()
        assertSnapshot(matching: viewController.view, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
}
