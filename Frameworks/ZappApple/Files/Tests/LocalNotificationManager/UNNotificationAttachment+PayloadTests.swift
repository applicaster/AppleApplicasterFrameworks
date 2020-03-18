//
// UNNotificationAttachment+PayloadTests.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/9/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import XCTest
@testable import ZappApple

class UNNotificationAttachmentPayloadTests: XCTestCase {
    func testContent() {
        let content: UNMutableNotificationContent = UNMutableNotificationContent(payload: content_dummy)
        XCTAssertTrue(content.title == "Title")
        XCTAssertTrue(content.subtitle == "Subtitle")
        XCTAssertTrue(content.body == "Body")
        XCTAssertTrue(content.badge == 1)
        XCTAssertTrue(content.sound == UNNotificationSound.default)
    }
}
