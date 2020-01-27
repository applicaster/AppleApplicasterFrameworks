//
//  PushPluginsManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation
import ZappCore

class PushPluginsManager: PluginManagerBase {
    typealias pluginTypeProtocol = PushProviderProtocol
    
    override func prepareManager(completion: PluginManagerCompletion) {
        providers = []
        enableAllProviders(completion: completion)
    }

    func enableAllProviders(completion: PluginManagerCompletion) {
        createProviders(pluginType: .Push,
                        Protocol: pluginTypeProtocol.self) { createdProviders in
            if let createdProviders = createdProviders as? [PushProviderProtocol] {
                providers = createdProviders
                completion()
            }
        }
    }
}
