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
    
    required init() {
        super.init()
        self.pluginType = .Push
    }
    
    override func prepareManager(completion: PluginManagerCompletion) {
        providers = [:]
        createProviders(completion: completion)
    }

    public override func providerCreated(provider:PluginAdapterProtocol,
                                 completion: PluginManagerCompletion) {
        if let provder = provider as? PushProviderProtocol {
            
        }
        completion()
    }
}
