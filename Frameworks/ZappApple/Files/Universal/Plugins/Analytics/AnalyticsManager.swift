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
@objc open class AnalyticsManager: NSObject {
    @objc public var analyticsProviders: [AnalyticsProviderProtocol] = []

    @objc public private(set) var currentScreenViewTitle: String?

    public func clearAnalyticsProviders() {
        analyticsProviders = []
    }

    public func prepareManager(completion: AnalyticManagerPreparationCompletion) {
        clearAnalyticsProviders()
        createAnalyticsProviders(completion: completion)
    }

    func createAllAnalyticsProviders() -> [AnalyticsProviderProtocol] {
        var providers = [AnalyticsProviderProtocol]()
        let pluginModels = PluginsManager.pluginModels()?.filter {
            $0.pluginType == .Analytics
        }
        if let pluginModels = pluginModels {
            for pluginModel in pluginModels {
                if let classType = PluginsManager.adapterClass(pluginModel) as? AnalyticsProviderProtocol.Type {
                    let provider = classType.init(configurationJSON:
                        pluginModel.configurationJSON)
                    provider.setPluginModel?(pluginModel)
                    providers.append(provider)
                }
            }
        }

        return providers
    }

    public func createAnalyticsProviders(completion: AnalyticManagerPreparationCompletion) {
        let pluggableProviders = createAllAnalyticsProviders()
        pluggableProviders.enumerated().forEach { index, provider in
            provider.prepareProvider(mandatoryDefaultParams()) { _ in
                analyticsProviders.append(provider)
            }
            if pluggableProviders.count == index {
                completion()
            }
        }
        completion()
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
        for provider in analyticsProviders {
            let parameters = parameters ?? [:]
            provider.sendEvent(name,
                               parameters: parameters)
        }
    }

    public func startObserveTimedEvent(name: String,
                                       parameters: Dictionary<String, Any>?) {
        let parameters = parameters ?? [:]

        for provider in analyticsProviders {
            provider.startObserveTimedEvent?(name,
                                             parameters: parameters)
        }
    }

    @objc open func stopObserveTimedEvent(_ eventName: String,
                                          parameters: [String: Any]?) {
        let parameters = parameters ?? [:]
        for provider in analyticsProviders {
            provider.stopObserveTimedEvent?(eventName, parameters: parameters)
        }
    }

    public func sendScreenEvent(screenTitle: String,
                                parameters: [String: Any]?) {
        if currentScreenViewTitle != screenTitle {
            var parameters = parameters as? [String: NSObject] ?? [:]
            parameters["Trigger"] = NSString(string: screenTitle)
            for provider in analyticsProviders {
                provider.sendScreenEvent(screenTitle, parameters: parameters)
            }
            currentScreenViewTitle = screenTitle
        }
    }
}
