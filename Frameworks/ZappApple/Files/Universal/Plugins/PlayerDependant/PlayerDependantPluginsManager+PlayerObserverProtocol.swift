
//
//  QBPlayerObserverProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 7/25/19.
//

import Foundation
import ZappCore

extension PlayerDependantPluginsManager: PlayerObserverProtocol {
    public func playerDidFinishPlayItem(player: PlayerProtocol,
                                        completion: @escaping (_ completion: Bool) -> Void) {
        var finishedProviderCount = 0
        guard let providers = providers(playerPlugin: player),
            providers.count > 0 else {
            completion(true)
            return
        }
        
        providers.forEach { provider in
            if let provider = provider as? PlayerObserverProtocol {
                provider.playerDidFinishPlayItem(player: player, completion: { _ in
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

    public func playerProgressUpdate(player: PlayerProtocol,
                                     currentTime: TimeInterval,
                                     duration: TimeInterval) {
        if let providers = providers(playerPlugin: player) {
            providers.forEach { provider in
                if let provider = provider as? PlayerObserverProtocol {
                    provider.playerProgressUpdate(player: player,
                                                  currentTime: currentTime,
                                                  duration: duration)
                }
            }
        }
    }

    public func playerDidDismiss(player: PlayerProtocol) {
        if let providersForPlayer = providers(playerPlugin: player) {
            providersForPlayer.forEach { provider in
                if let provider = provider as? PlayerObserverProtocol {
                    provider.playerDidDismiss(player: player)
                }
            }
            unRegisterProviders(playerPlugin: player)
        }
    }

    public func playerDidCreate(player: PlayerProtocol) {
        guard let playerPlugin = player as? (PlayerProtocol & DependablePlayerPluginProtocol) else {
            return
        }
        unRegisterProviders(playerPlugin: player)

        let dependantPlayerProviders = createPlayerDependantProviders(for: player)

        if dependantPlayerProviders.count > 0 {
            providers["\(playerPlugin.hash)"] = dependantPlayerProviders
        }
    }
}
