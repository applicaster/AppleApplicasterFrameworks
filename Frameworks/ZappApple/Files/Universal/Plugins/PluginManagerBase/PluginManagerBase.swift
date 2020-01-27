//
//  PluginManagerBase.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation
import ZappCore

class PluginManagerBase: PluginManagerProtocol {
    
    open var pluginProtocol: PluginAdapterProtocol.Protocol {
        return pluginTypeProtocol.self
    }
    
    
    public typealias pluginTypeProtocol = PluginAdapterProtocol

    open var providers: [pluginTypeProtocol] = []

    func prepareManager(completion: () -> Void) {
        
    }

    public func createProviders(pluginType: ZPPluginType,
                                Protocol: Protocol,
                                forceEnable: Bool = false,
                                completion: (_ finished:Bool) -> Void) {
        var providers: [PluginAdapterProtocol] = []
        let pluginModels = PluginsManager.pluginModels()?.filter {
            $0.pluginType == pluginType
        }

        if let pluginModels = pluginModels {
            var counter = pluginModels.count
            for pluginModel in pluginModels {
                createProvider(pluginModel: pluginModel,
                               Protocol: Protocol,
                               forceEnable: forceEnable) { provider in

                    counter -= 1
                    if let provider = provider as? PluginAdapterProtocol {
                        providers.append(provider)
                    }
                    if counter == 0,
                        let providers = providers as? [Protocol] {
                        completion(providers)
                    }
                }
            }
        } else {
            completion([])
        }
    }

    public func createProvider(identifier: String,
                               Protocol: Protocol,
                               forceEnable: Bool = false,
                               completion: (_ provider: Protocol?) -> Void) {
        guard let pluginModel = PluginsManager.pluginModelById(identifier) else {
            completion(nil)
            return
        }
        createProvider(pluginModel: pluginModel,
                       Protocol: Protocol,
                       forceEnable: forceEnable,
                       completion: completion)
    }

    public func createProvider(pluginModel: ZPPluginModel,
                               Protocol: Protocol,
                               forceEnable: Bool = false,
                               completion: (_ provider: Protocol?) -> Void) {
        if let adapterClass = PluginsManager.adapterClass(pluginModel),
            adapterClass.conforms(to: Protocol),
            let classType = adapterClass as? PluginAdapterProtocol.Type,
            isEnabled(pluginModel: pluginModel,
                      forceEnable: forceEnable) {
            let provider = classType.init(pluginModel: pluginModel)

            _ = FacadeConnector.connector?.storage?.sessionStorageSetValue(for: kPluginEnabled,
                                                                           value: kPluginEnabledValue,
                                                                           namespace: pluginModel.identifier)
            completion(provider as? Protocol)
        } else {
            _ = FacadeConnector.connector?.storage?.sessionStorageSetValue(for: kPluginEnabled,
                                                                           value: kPluginDisabledValue,
                                                                           namespace: pluginModel.identifier)
        }
        completion(nil)
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
