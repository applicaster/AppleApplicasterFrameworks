//
//  PlayerDependantPluginsManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 10/17/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappCore

@objc public class PlayerDependantPluginsManager: NSObject {
    /// List of registered providers for player Plugins
    var providers: [String: [PlayerDependantPluginProtocol]] = [:]

    /// Unregister dependants plugins
    ///
    /// - Parameter playerPlugin: Player plugin that conform ZPDependablePlayerPluginProtocol that uses dependant plugins
    @objc public func unRegisterProviders(playerPlugin: PlayerProtocol) {
        providers["\(playerPlugin.hash)"] = nil
    }

    /// Retrieve list provider for plugin
    ///
    /// - Parameter playerPlugin: Player plugin that conform ZPDependablePlayerPluginProtocol that uses dependant plugins
    /// - Returns: Array of instances of the dependant providers that are conforming ZPPlayerDependantPluginProtocol protocol
    @objc public func providers(playerPlugin: PlayerProtocol) -> [PlayerDependantPluginProtocol]? {
        return providers["\(playerPlugin.hash)"]
    }

     @objc public func createPlayerDependantProviders(for player: PlayerProtocol) -> [PlayerDependantPluginProtocol] {
        var retVal: [PlayerDependantPluginProtocol] = []

        guard let playerPlugin = player as? (PlayerProtocol & DependablePlayerPluginProtocol) else {
            return retVal
        }

        let pluginModels = FacadeConnector.connector?.pluginManager?.getAllPlugins()?.filter {
            guard let pluginTypeString = $0.pluginType?.rawValue else { return false }
            return playerPlugin.supportedDependantPluginType.contains(pluginTypeString)
        }

        if let pluginModels = pluginModels {
            for pluginModel in pluginModels {
                if let classType = FacadeConnector.connector?.pluginManager?.adapterClass(pluginModel) as? PlayerDependantPluginProtocol.Type,
                    let provider = classType.init(configurationJSON: pluginModel.configurationJSON) as? (PlayerObserverProtocol & PlayerDependantPluginProtocol) {
                    provider.playerPlugin = playerPlugin
                    provider.playerDidCreate(player: playerPlugin)
                    retVal.append(provider)
                }
            }
        }
        return retVal
    }
}
