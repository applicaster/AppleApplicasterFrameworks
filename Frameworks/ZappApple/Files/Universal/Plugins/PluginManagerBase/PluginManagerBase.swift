//
//  PluginManagerBase.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation
import ZappCore

public class PluginManagerBase: PluginManagerProtocol {
    open var pluginType: ZPPluginType

    required init() {
        pluginType = .Unknown
    }

    open var pluginProtocol: PluginAdapterProtocol.Protocol {
        return pluginTypeProtocol.self
    }

    public typealias pluginTypeProtocol = PluginAdapterProtocol

    open var providers: [String: pluginTypeProtocol] = [:]

    func prepareManager(completion: PluginManagerCompletion) {
        providers = [:]
        createProviders(completion: completion)
    }

    public func providerCreated(provider: PluginAdapterProtocol,
                                completion: PluginManagerCompletion) {
        provider.prepareProvider([:]) { succeed in
            completion?(succeed)
        }
        // Must be implemented on subclass if needed
    }

    public func createProviders(forceEnable: Bool = false,
                                completion: PluginManagerCompletion) {
        let pluginModels = PluginsManager.pluginModels()?.filter {
            $0.pluginType == pluginType
        }

        if let pluginModels = pluginModels {
            var counter = pluginModels.count
            for pluginModel in pluginModels {
                createProvider(pluginModel: pluginModel,
                               forceEnable: forceEnable) { _ in
                    counter -= 1

                    if counter == 0 {
                        completion?(true)
                    }
                }
            }
        } else {
            completion?(false)
        }
    }

    public func createProvider(identifier: String,
                               forceEnable: Bool = false,
                               completion: PluginManagerCompletion) {
        guard let pluginModel = PluginsManager.pluginModelById(identifier) else {
            completion?(false)
            return
        }
        createProvider(pluginModel: pluginModel,
                       forceEnable: forceEnable,
                       completion: completion)
    }

    public func createProvider(pluginModel: ZPPluginModel,
                               forceEnable: Bool = false,
                               completion: PluginManagerCompletion) {
        if let adapterClass = PluginsManager.adapterClass(pluginModel),
            adapterClass.conforms(to: pluginProtocol),
            let classType = adapterClass as? PluginAdapterProtocol.Type,
            isEnabled(pluginModel: pluginModel,
                      forceEnable: forceEnable) {
            let provider = classType.init(pluginModel: pluginModel)

            providers[pluginModel.identifier] = provider

            _ = FacadeConnector.connector?.storage?.sessionStorageSetValue(for: kPluginEnabled,
                                                                           value: kPluginEnabledValue,
                                                                           namespace: pluginModel.identifier)

            providerCreated(provider: provider,
                            completion: completion)
        } else {
            _ = FacadeConnector.connector?.storage?.sessionStorageSetValue(for: kPluginEnabled,
                                                                           value: kPluginDisabledValue,
                                                                           namespace: pluginModel.identifier)
            completion?(true)
        }
    }

    public func disablePlugin(identifier: String,
                              completion: PluginManagerCompletion) {
        guard let provider = providers[identifier],
            let pluginModel = provider.model else {
            completion?(false)
            return
        }
        provider.disable(completion: completion)
        _ = FacadeConnector.connector?.storage?.sessionStorageSetValue(for: kPluginEnabled,
                                                                       value: kPluginDisabledValue,
                                                                       namespace: pluginModel.identifier)
        completion?(true)
    }

    public func disablePlugins(completion: PluginManagerCompletion) {
        guard providers.count > 0 else {
            completion?(true)
            return
        }

        var counter = providers.count
        providers.forEach { element in
            element.value.disable { _ in
                counter -= 1
                if counter == 0 {
                    completion?(true)
                }
            }
        }
    }

    public func isEnabled(pluginModel: ZPPluginModel,
                          forceEnable: Bool) -> Bool {
        var retVal = true
        guard forceEnable == false else {
            return retVal
        }

        guard let configurationJSON = pluginModel.configurationJSON,
            let pluginEnabled = configurationJSON[kPluginEnabled] else {
            return retVal
        }

        if let pluginEnabled = pluginEnabled as? String,
            let pluginEnabledBool = Bool(pluginEnabled) {
            retVal = pluginEnabledBool
        } else if let pluginEnabled = pluginEnabled as? Bool {
            retVal = pluginEnabled
        }

        return retVal
    }
}
