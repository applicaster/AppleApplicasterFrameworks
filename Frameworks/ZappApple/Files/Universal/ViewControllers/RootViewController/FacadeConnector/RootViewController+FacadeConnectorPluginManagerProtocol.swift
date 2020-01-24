//
//  RootViewController+FacadeConnectorPluginManagerProtocol.swift
//  ZappApple
//
//  Created by Anton Kononenko on 10/15/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappCore

extension RootViewController: FacadeConnectorPluginManagerProtocol {
    public func pluginModel(_ type: String) -> ZPPluginModel? {
        return PluginsManager.pluginModel(type)
    }

    @objc public func plugin(for identifier: String) -> ZPPluginModel? {
        return PluginsManager.pluginModelById(identifier)
    }

    @objc public func getAllPlugins() -> [ZPPluginModel]? {
        return PluginsManager.allPluginModels
    }

    @objc public func adapterClass(_ pluginModel: ZPPluginModel) -> AnyClass? {
        return PluginsManager.adapterClass(pluginModel)
    }

    @objc func disablePlugin(identifier: String) {
        
    }

    @objc func disableAllPlugins(pluginType: String) {
    }

    @objc func enablePlugin(identifier: String) {
    }

    @objc func enableAllPlugins(pluginType: String) {
    }
}
