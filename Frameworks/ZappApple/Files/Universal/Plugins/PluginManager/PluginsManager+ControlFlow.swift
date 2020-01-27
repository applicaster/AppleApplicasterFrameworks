//
//  ZPPluginManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation
import ZappCore

public let kPluginEnabled = "enabled"
public let kPluginEnabledValue = "true"
public let kPluginDisabledValue = "false"

extension PluginsManager {
    func disablePlugin(identifier: String) {
//        guard let pluginManager = pluginManager(identifier: identifier) else {
//            return
//        }
    }

    func disableAllPlugins(pluginType: String) {
        guard let pluginType = ZPPluginType(rawValue: pluginType),
            let manager = pluginManager(type: pluginType) else {
                return
        }
//        manager.providers.forEach { (provider) in
//            _ = FacadeConnector.connector?.storage?.sessionStorageSetValue(for: kPluginEnabled,
//                                                                               value: kPluginDisabledValue,
//                                                                               namespace: pluginModel.identifier)
//        }
    }

    func enablePlugin(identifier: String) {
//        guard let pluginManager = pluginManager(identifier: identifier) else {
//            return
//        }
//
    }

    func enableAllPlugins(pluginType: String) {
        guard let pluginType = ZPPluginType(rawValue: pluginType),
            let manager = pluginManager(type: pluginType) else {
            return
        }
        manager.createProviders(pluginType: pluginType,
                                Protocol:  manager.pluginProtocol) { providers in
                                    if let providers = providers as? manager.pluginProtocol {
                                        manager.providers = providers
                                    } else {
                                        
                                    }
            
        }
    }

    func pluginManager(identifier: String) -> PluginManagerBase? {
        guard let plugin = PluginsManager.pluginModelById(identifier),
            let pluginType = plugin.pluginType else {
            return nil
        }

        return pluginManager(type: pluginType)
    }

    func pluginManager(type: ZPPluginType) -> PluginManagerBase? {
        // In switch defined supported control flow types plugins.
        switch type {
        case .Push:
            return push
        default:
            return nil
        }
    }
}

// PluginManagerBase
