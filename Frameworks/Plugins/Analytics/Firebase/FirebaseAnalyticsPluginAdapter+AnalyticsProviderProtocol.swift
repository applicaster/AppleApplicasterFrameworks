//
//  FirebaseAnalyticsPluginAdapter+AnalyticsProviderProtocol.swift
//  AppleApplicasterFrameworks
//
//  Created by Anton Kononenko on 12/26/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Firebase
import Foundation
import ZappCore

extension FirebaseAnalyticsPluginAdapter: AnalyticsProviderProtocol {
    var providerName: String {
        return "firebase"
    }

    func prepareProvider(_ mandatoryDefaultParams: [String: Any], completion: (Bool) -> Void) {
        FirebaseApp.configure()

        defaultEventParameters = mandatoryDefaultParams
        completion(true)
    }

    func sendEvent(_ eventName: String,
                   parameters: [String: Any]?) {
        let combinedProperties = combineProperties(combinedWithEventParams: parameters)

        Analytics.logEvent(eventName,
                           parameters: combinedProperties)
    }

    func sendScreenEvent(_ screenName: String,
                         parameters: [String: Any]?) {
        Analytics.setScreenName(screenName,
                                screenClass: nil)
    }

    func startObserveTimedEvent(_ eventName: String,
                                parameters: [String: Any]?) {
        registerTimedEvent(eventName,
                           parameters: parameters)
    }

    func stopObserveTimedEvent(_ eventName: String,
                               parameters: [String: Any]?) {
        processEndTimedEvent(eventName,
                             parameters: parameters)
    }
}
