//
//  CrashlogsPluginsManager.swift
//  CrashlogsPluginsManager
//
//  Created by Anton Kononenko on 12/25/18.
//  Copyright © 2019 Applicaster. All rights reserved.
//

import ZappCore

public class CrashlogsPluginsManager {
    var providers: [CrashlogsPluginProtocol] = []

    init() {
        createСrashlogProviders()
    }

    public func createСrashlogProviders() {
        let pluginModels = PluginsManager.pluginModels()?.filter { $0.pluginType == .Crashlogs }

        if let models = pluginModels, models.count > 0 {
            for model in models {
                if let classType = PluginsManager.adapterClass(model) as? CrashlogsPluginProtocol.Type {
                    let provider = classType.init(configurationJSON: model.configurationJSON)
                    provider.prepareProvider { succeed in
                        if succeed {
                            providers.append(provider)
                        }
                    }
                }
            }
        }
    }
}
