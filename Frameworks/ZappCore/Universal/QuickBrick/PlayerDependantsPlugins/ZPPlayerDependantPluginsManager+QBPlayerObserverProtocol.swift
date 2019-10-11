
//
//  QBPlayerObserverProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 7/25/19.
//

import Foundation

extension ZPPlayerDependantPluginsManager: QBPlayerObserverProtocol {
    public func playerDidFinishPlayItem(player:QBPlayerProtocol,
                                 completion:@escaping (_ completion:Bool) -> Void) {
        var finishedProviderCount = 0
        if let providers = ZPPlayerDependantPluginsManager.providers(playerPlugin: player) {
            providers.forEach { (provider) in
                if let provider = provider as? QBPlayerObserverProtocol {
                    provider.playerDidFinishPlayItem(player: player, completion: { (finished) in
                        finishedProviderCount += 1
                        if finishedProviderCount == providers.count {
                            completion(true)
                        }
                    })
                } else {
                    finishedProviderCount += 1
                    if finishedProviderCount == providers.count {
                        completion(true)
                    }
                }
            }
        }   
    }
    
    public func playerProgressUpdate(player:QBPlayerProtocol, currentTime:TimeInterval, duration:TimeInterval) {
        if let providers = ZPPlayerDependantPluginsManager.providers(playerPlugin: player) {
            providers.forEach { (provider) in
                if let provider = provider as? QBPlayerObserverProtocol {
                    provider.playerProgressUpdate(player: player,
                                                  currentTime:currentTime,
                                                  duration:duration)
                }
            }
        }
    }
    
    public func playerDidDismiss(player: QBPlayerProtocol) {
        if let providersForPlayer = ZPPlayerDependantPluginsManager.providers(playerPlugin: player) {
          
            providersForPlayer.forEach { (provider) in
                if let provider = provider as? QBPlayerObserverProtocol {
                    provider.playerDidDismiss(player: player)
                }
            }
            ZPPlayerDependantPluginsManager.unRegisterProviders(playerPlugin: player)
        }
    }
    
    public func playerDidCreate(player:QBPlayerProtocol) {
        guard let playerPlugin = player as? (QBPlayerProtocol & ZPDependablePlayerPluginProtocol) else {
            return
        }
        
        ZPPlayerDependantPluginsManager.unRegisterProviders(playerPlugin: player)
        
        var playerProviders:[ZPPlayerDependantPluginProtocol] = []
        
        let pluginModels = FacadeConnector.connector?.pluginManager?.getAllPlugins()?.filter {
            guard let pluginTypeString = $0.pluginType?.rawValue else { return false}
            return playerPlugin.supportedDependantPluginType.contains(pluginTypeString)
        }
        
        if let pluginModels = pluginModels  {
            for pluginModel in pluginModels {
                if let classType = FacadeConnector.connector?.pluginManager?.adapterClass(pluginModel) as? ZPPlayerDependantPluginProtocol.Type,
                    let provider = classType.init(configurationJSON: pluginModel.configurationJSON) as? (QBPlayerObserverProtocol & ZPPlayerDependantPluginProtocol) {

                    provider.playerPlugin = playerPlugin
                    provider.playerDidCreate(player: playerPlugin)
                    playerProviders.append(provider)

                }
            }
        }
        
        if playerProviders.count > 0 {
            ZPPlayerDependantPluginsManager.providers["\(playerPlugin.hash)"] = playerProviders
        }
    }
}
