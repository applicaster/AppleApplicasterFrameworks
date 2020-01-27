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
    func disablePlugin(identifier: String, completion: ((_ success: Bool) -> Void)?) {
        guard let manager = pluginManager(identifier: identifier) else {
            return
        }

        manager.disablePlugin(identifier: identifier, completion: completion)
    }

    func disableAllPlugins(pluginType: String, completion: ((_ success: Bool) -> Void)?) {
        guard let pluginType = ZPPluginType(rawValue: pluginType),
            let manager = pluginManager(type: pluginType) else {
            return
        }
        manager.disablePlugins(completion: completion)
    }

    func enablePlugin(identifier: String, completion: ((_ success: Bool) -> Void)?) {
        guard let pluginManager = pluginManager(identifier: identifier) else {
            return
        }

        pluginManager.createProvider(identifier: identifier, forceEnable: true, completion: completion)
    }

    func enableAllPlugins(pluginType: String, completion: ((_ success: Bool) -> Void)?) {
        guard let pluginType = ZPPluginType(rawValue: pluginType),
            let manager = pluginManager(type: pluginType) else {
            return
        }
        manager.createProviders(forceEnable: true, completion: completion)
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
