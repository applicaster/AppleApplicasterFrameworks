//
//  PushPluginsManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/24/20.
//

import Foundation
import ZappCore

class PushPluginsManager {
    var providers: [PushProviderProtocol] = []

    init() {
        createСrashlogProviders()
    }

    public func createСrashlogProviders() {
        let pluginModels = PluginsManager.pluginModels()?.filter { $0.pluginType == .Push }

        if let models = pluginModels, models.count > 0 {
            for model in models {
                if let classType = PluginsManager.adapterClass(model) as? PushProviderProtocol.Type {
                    let provider = classType.init(configurationJSON: model.configurationJSON)
                    provider.prepareProvider([:]) { succeed in
                        if succeed {
                            providers.append(provider)
                        }
                    }
                }
            }
        }
    }
}
