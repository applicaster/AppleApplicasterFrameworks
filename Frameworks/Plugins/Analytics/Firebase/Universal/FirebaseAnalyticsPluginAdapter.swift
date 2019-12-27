//
//  FirebaseAnalyticsPluginAdapter.swift
//  AppleApplicasterFrameworks
//
//  Created by Anton Kononenko on 12/26/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappCore

class FirebaseAnalyticsPluginAdapter: NSObject, ZPAdapterProtocol {
    var configurationJSON: NSDictionary?

    /// Define if screen view enabled in plugin
    var isScreenViewsEnabled: Bool = false

    var defaultEventParameters: [String: Any] = [:]
    var timedEventsDictionary: [String: APTimedEvent] = [:]
    public required init(configurationJSON: NSDictionary?) {
        self.configurationJSON = configurationJSON
    }

    public required override init() {
        super.init()
    }

    public func registerTimedEvent(_ eventName: String,
                                   parameters: [String: Any]?) {
        if let currentEvent = self.timedEventsDictionary[eventName] {
            processEndTimedEvent(currentEvent.eventName,
                                 parameters: currentEvent.parameters)
        }

        let timedEvent = APTimedEvent(eventName: eventName,
                                      parameters: parameters as? [String : NSObject],
                                      startTime: Date())
        timedEventsDictionary[eventName] = timedEvent
    }

    public func processEndTimedEvent(_ eventName: String, parameters: [String: Any]?) {
        if let timedEvent = self.timedEventsDictionary[eventName] {
            // Handle merging parameters with the later ones overriding the earlier ones if needed
            let parameters = parameters ?? [:] as [String: Any]
            let timedEventParameters = timedEvent.parameters ?? [:] as [String: Any]
            var mergedParameters = timedEventParameters.merging(parameters) { _, new in new }
            mergedParameters["Event Duration"] = "\(Int(abs(timedEvent.startTime.timeIntervalSinceNow)))" as Any
            timedEvent.parameters = mergedParameters as? [String : NSObject]
            sendEvent(timedEvent.eventName,
                      parameters: mergedParameters)
            timedEventsDictionary.removeValue(forKey: eventName)
        }
    }

    public func combineProperties(combinedWithEventParams eventParams: [String: Any]?) -> [String: Any] {
        var properties: [String: Any] = [:]
        if let eventParams = eventParams {
            properties = eventParams
        }

        // return merging gathered properties with default properties
        return properties.merging(defaultEventParameters) { _, new in new }
    }
    
}
