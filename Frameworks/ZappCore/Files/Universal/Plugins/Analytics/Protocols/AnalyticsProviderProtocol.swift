//
//  AnalyticsProviderProtocol.swift
//  ZappAnalyticsPluginsSDK
//
//  Created by Anton Kononenko on 10/16/19.
//  Copyright © 2019 Applicaster. All rights reserved.
//

import Foundation

/// Conforming this protocol allows Zapp Analytics plugin to support generic analytics system of Zapp App
@objc public protocol AnalyticsProviderProtocol: ZPAdapterProtocol {
    /// Readable name of the analytics plugin
    @objc var providerName: String { get }

    /// Invokation of this function must prepare analytics plugin for use.
    /// - Attention: Application will wait completion of this func to present application.
    /// Completion must be called as soon as  possible
    /// - Parameters:
    ///   - mandatoryDefaultParams: default parameters for analytics plugins
    ///   - completion: Completion handler that notify app level that component  ready to  be presented or fail
    ///   - isReady: notify callback if analytics plugin is ready for use
    func prepareProvider(_ mandatoryDefaultParams: [String: Any],
                         completion: (_ isReady: Bool) -> Void)

    /// Invokation of this function must send event to analytics provider
    /// - Parameters:
    ///   - eventName: Unique event name that used as event key
    ///   - parameters: Dictionary that should be passed as values for specific event
    @objc func sendEvent(_ eventName: String,
                         parameters: [String: Any]?)

    /// Invokation of this function must send screen event to analytics provider
    /// - Note: If plugin does not support screen events, logic can be passed default event with parameters
    /// - Parameters:
    ///   - screenName: Unique screen name
    ///   - parameters: Dictionary that should be passed as values for specific event
    @objc func sendScreenEvent(_ screenName: String,
                               parameters: [String: Any]?)

    /// Invokation of this method will notify analytics plugin that timed event was started
    /// Plugin should wait until stopObserveTimedEvent: will be called
    /// - Parameters:
    ///   - eventName: Unique event name that used as event key
    ///   - parameters: Dictionary that should be passed as values for specific event
    @objc optional func startObserveTimedEvent(_ eventName: String,
                                               parameters: [String: Any]?)

    /// Invokation of this method will notify analytics plugin that timed event was finished
    /// Call of this method should send timed event to analytics provider
    /// - Parameters:
    ///   - eventName: Unique event name that used as event key
    ///   - parameters: Dictionary that should be passed as values for specific event
    @objc optional func stopObserveTimedEvent(_ eventName: String,
                                              parameters: [String: Any]?)
}
