//
//  APTimedEvent.swift
//  ZappCore
//
//  Created by Anton Kononenko on 12/27/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation

@objc open class APTimedEvent: NSObject {
    public var eventName: String
    public var parameters: [String: NSObject]?
    public var startTime: Date

    public init(eventName: String, parameters: [String: NSObject]?, startTime: Date) {
        self.eventName = eventName
        self.parameters = parameters
        self.startTime = startTime
    }
}
