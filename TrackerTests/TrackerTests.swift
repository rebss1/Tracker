//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Илья Лощилов on 25.09.2024.
//

import SnapshotTesting
@testable import Tracker
import XCTest

final class TrackerTests: XCTestCase {

    func testLightViewController() {
        let vc = TrackerViewController()
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .light))])
    }
    
    func testDarkViewController() {
        let vc = TrackerViewController()
        assertSnapshots(of: vc, as: [.image(traits: .init(userInterfaceStyle: .dark))])
    }
}
