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
        guard let manager = pluginManager(identifier: identifier) else {
            return
        }
        manager.disablePlugin(identifier: identifier) {
        }
    }

    func disableAllPlugins(pluginType: String) {
        guard let pluginType = ZPPluginType(rawValue: pluginType),
            let manager = pluginManager(type: pluginType) else {
            return
        }
        manager.disablePlugins {}
    }

    func enablePlugin(identifier: String) {
        guard let pluginManager = pluginManager(identifier: identifier) else {
            return
        }

        pluginManager.createProvider(identifier: identifier,
                                     forceEnable: true) {
        }
    }

    func enableAllPlugins(pluginType: String) {
        guard let pluginType = ZPPluginType(rawValue: pluginType),
            let manager = pluginManager(type: pluginType) else {
            return
        }
        manager.createProviders(forceEnable: true) {
            print("enableAllPlugins")
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
