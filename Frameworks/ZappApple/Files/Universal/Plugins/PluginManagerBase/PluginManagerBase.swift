//
//  PluginManagerBase.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation
import ZappCore

class PluginManagerBase: PluginManagerProtocol {
    open var pluginType: ZPPluginType

    required init() {
        pluginType = .Unknown
    }

    open var pluginProtocol: PluginAdapterProtocol.Protocol {
        return pluginTypeProtocol.self
    }

    public typealias pluginTypeProtocol = PluginAdapterProtocol

    open var providers: [String: pluginTypeProtocol] = [:]

    func prepareManager(completion: () -> Void) {
        // Must be implemented on subclass if needed
    }

    public func providerCreated(provider: PluginAdapterProtocol,
                                completion: PluginManagerCompletion) {
        provider.prepareProvider([:]) { _ in
            completion()
        }
        // Must be implemented on subclass if need
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
                               forceEnable: forceEnable) {
                    counter -= 1

                    if counter == 0 {
                        completion()
                    }
                }
            }
        } else {
            completion()
        }
    }

    public func createProvider(identifier: String,
                               forceEnable: Bool = false,
                               completion: PluginManagerCompletion) {
        guard let pluginModel = PluginsManager.pluginModelById(identifier) else {
            completion()
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
        }
        completion()
    }

    public func disablePlugin(identifier: String,
                              completion: @escaping PluginManagerCompletion) {
        guard let provider = providers[identifier],
            let pluginModel = provider.model else {
            completion()
            return
        }
        provider.disable(completion: completion)
        _ = FacadeConnector.connector?.storage?.sessionStorageSetValue(for: kPluginEnabled,
                                                                       value: kPluginDisabledValue,
                                                                       namespace: pluginModel.identifier)
        completion()
    }

    public func disablePlugins(completion: @escaping PluginManagerCompletion) {
        guard providers.count > 0 else {
            completion()
            return
        }

        var counter = providers.count
        providers.enumerated().forEach { _, element in
            element.value.disable {
                counter -= 1
                if counter == 0 {
                    completion()
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
