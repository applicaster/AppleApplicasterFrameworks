//
//  AnalyticsProviderProtocol.swift
//  ZappAnalyticsPluginsSDK
//
//  Created by Anton Kononenko on 10/16/19.
//  Copyright © 2019 Applicaster. All rights reserved.
//

import Foundation

@objc public protocol AnalyticsProviderProtocol: ZPAdapterProtocol {
    @objc var providerName: String { get }
    func prepareProvider(_ mandatoryDefaultParams: [String: Any],
                         completion: (_ isReady: Bool) -> Void)

    @objc func sendEvent(_ eventName: String,
                         parameters: [String: Any]?)

    @objc func sendScreenEvent(_ screenName: String,
                               parameters: [String: Any]?)

    @objc optional func startObserveTimedEvent(_ eventName: String,
                                               parameters: [String: Any]?)
    @objc optional func stopObserveTimedEvent(_ eventName: String,
                                              parameters: [String: Any]?)
}
