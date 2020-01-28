//
//  AnalyticsManager.swift
//  ZappAnalyticsPluginsSDK
//
//  Created by Anton Kononenko on 11/22/18.
//  Copyright © 2018 Applicaster. All rights reserved.
//

import UIKit
import ZappCore

public typealias AnalyticManagerPreparationCompletion = () -> Void
public typealias ProviderSendAnalyticsCompletion = (_ provider: AnalyticsProviderProtocol,
                                                    _ success: Bool) -> Void
public class AnalyticsManager: PluginManagerBase {
    typealias pluginTypeProtocol = AnalyticsProviderProtocol
    var _providers: [AnalyticsProviderProtocol] {
        let providersArray = providers.map { $0.value }
        return providersArray as! [AnalyticsProviderProtocol]
    }

    public required init() {
        super.init()
        pluginType = .Analytics
    }

    @objc public private(set) var currentScreenViewTitle: String?

    public override func providerCreated(provider: PluginAdapterProtocol,
                                         completion: PluginManagerCompletion) {
        provider.prepareProvider(mandatoryDefaultParams()) { succeed in
            completion?(succeed)
        }
        // Must be implemented on subclass if needed
    }

    func mandatoryDefaultParams() -> [String: Any] {
        var defaultParams: [String: Any] = [:]

        if let uuid = UIDevice.current.identifierForVendor?.uuidString,
            String.isNotEmptyOrWhitespace(uuid) {
            defaultParams["uuid"] = uuid
        }
        let sessionStorage = SessionStorage.sharedInstance
        if let versionName = sessionStorage.get(key: ZappStorageKeys.versionName,
                                                namespace: nil),
            String.isNotEmptyOrWhitespace(versionName) {
            defaultParams["Version Name"] = versionName
        }

        if let buildVersion = sessionStorage.get(key: ZappStorageKeys.buildVersion,
                                                 namespace: nil),
            String.isNotEmptyOrWhitespace(buildVersion) {
            defaultParams["Bundle Version"] = buildVersion
        }

        if let riversConfigurationId = sessionStorage.get(key: ZappStorageKeys.riversConfigurationId,
                                                          namespace: nil),
            String.isNotEmptyOrWhitespace(riversConfigurationId) {
            defaultParams["Rivers Configuration ID"] = riversConfigurationId
        }
        defaultParams["Morpheus Version"] = "2.0"

        return defaultParams
    }

    public func sendEvent(name: String,
                          parameters: [String: Any]?) {
        for provider in _providers {
            let parameters = parameters ?? [:]
            provider.sendEvent(name,
                               parameters: parameters)
        }
    }

    public func startObserveTimedEvent(name: String,
                                       parameters: Dictionary<String, Any>?) {
        let parameters = parameters ?? [:]

        for provider in _providers {
            provider.startObserveTimedEvent?(name,
                                             parameters: parameters)
        }
    }

    @objc open func stopObserveTimedEvent(_ eventName: String,
                                          parameters: [String: Any]?) {
        let parameters = parameters ?? [:]
        for provider in _providers {
            provider.stopObserveTimedEvent?(eventName, parameters: parameters)
        }
    }

    public func sendScreenEvent(screenTitle: String,
                                parameters: [String: Any]?) {
        if currentScreenViewTitle != screenTitle {
            var parameters = parameters as? [String: NSObject] ?? [:]
            parameters["Trigger"] = NSString(string: screenTitle)
            for provider in _providers {
                provider.sendScreenEvent(screenTitle, parameters: parameters)
            }
            currentScreenViewTitle = screenTitle
        }
    }
}
