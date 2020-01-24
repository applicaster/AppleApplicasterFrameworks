//
//  ZPPluginManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation
import ZappCore

extension PluginsManager {
    func disablePlugin(identifier: String) {
        guard let pluginManager = pluginManager(identifier: identifier) else {
            return
        }
    }

    func disableAllPlugins(pluginType: String) {
    }

    func enablePlugin(identifier: String) {
        guard let pluginManager = pluginManager(identifier: identifier) else {
            return
        }
    }

    func enableAllPlugins(pluginType: String) {
        guard let pluginType = ZPPluginType(rawValue: pluginType) else {
            return
        }
    }

    func pluginManager(identifier: String) -> Any? {
        guard let plugin = PluginsManager.pluginModelById(identifier),
            let pluginType = plugin.pluginType else {
            return nil
        }

        return pluginManager(type: pluginType)
    }

    func pluginManager(type: ZPPluginType) -> Any? {
        // In switch defined supported control flow types plugins.
        switch type {
        case .Push:
            return nil
        default:
            return nil
        }
    }
}
