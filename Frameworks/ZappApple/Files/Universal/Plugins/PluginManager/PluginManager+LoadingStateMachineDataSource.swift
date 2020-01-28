//
//  PluginManager+LoadingStateMachineDataSource.swift
//  ZappApple
//
//  Created by Anton Kononenko on 11/18/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation

extension PluginsManager: LoadingStateMachineDataSource {
    
    func preapareLoadingPluginStates() -> [LoadingState] {
        let loadPlugins = LoadingState()
        loadPlugins.stateHandler = loadPluginsGroup
        loadPlugins.readableName = "Load General Plugins JSON"

        let analytics = LoadingState()
        analytics.stateHandler = prepareAnalyticsPlugins
        analytics.dependantStates = [loadPlugins.name]
        analytics.readableName = "Prepare Analytics Plugins"

        let pluginsSessionStorageData = LoadingState()
        pluginsSessionStorageData.stateHandler = updatePluginSessionStorageData
        pluginsSessionStorageData.readableName = "Plugins Session Storage"
        pluginsSessionStorageData.dependantStates = [loadPlugins.name]
        return [loadPlugins,
                analytics,
                pluginsSessionStorageData]
    }
    
    public func stateMachineFinishedWork(with state: LoadingStateTypes) {
        pluginLoaderCompletion?(state == .success)
        pluginLoaderCompletion = nil
    }
}
