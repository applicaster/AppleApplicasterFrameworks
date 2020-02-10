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
        loadPlugins.readableName = "<plugins-state-machine> Load General Plugins JSON"

        let analytics = LoadingState()
        analytics.stateHandler = prepareAnalyticsPlugins
        analytics.dependantStates = [loadPlugins.name]
        analytics.readableName = "<plugins-state-machine> Prepare Analytics Plugins"

        let push = LoadingState()
        push.stateHandler = preparePushPlugins
        push.dependantStates = [loadPlugins.name]
        push.readableName = "<plugins-state-machine> Prepare Push Plugins"

        let general = LoadingState()
        general.stateHandler = prepareGeneralPlugins
        general.dependantStates = [loadPlugins.name]
        general.readableName = "<plugins-state-machine> Prepare General Plugins"

        let pluginsSessionStorageData = LoadingState()
        pluginsSessionStorageData.stateHandler = updatePluginSessionStorageData
        pluginsSessionStorageData.readableName = "<plugins-state-machine> Plugins Session Storage"
        pluginsSessionStorageData.dependantStates = [loadPlugins.name]
        return [loadPlugins,
                analytics,
                push,
                general,
                pluginsSessionStorageData]
    }

    public func stateMachineFinishedWork(with state: LoadingStateTypes) {
        pluginLoaderCompletion?(state == .success)
        pluginLoaderCompletion = nil
    }
}
