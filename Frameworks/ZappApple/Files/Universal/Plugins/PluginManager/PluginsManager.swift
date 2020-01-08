//
//  PluginsLoader.swift
//  ZappApple
//
//  Created by Anton Kononenko on 11/26/18.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappCore

class PluginsManager: NSObject {
    public lazy var analytics = AnalyticsManager()
    public lazy var playerDependants = PlayerDependantPluginsManager()
    public var crashlogs = CrashlogsPluginsManager()

    var pluginsStateMachine: LoadingStateMachine!
    var pluginLoaderCompletion: ((_ success: Bool) -> Void)?

    func intializePlugins(completion: @escaping (_ success: Bool) -> Void) {
        pluginLoaderCompletion = completion
        pluginsStateMachine = LoadingStateMachine(dataSource: self,
                                                  withStates: preapareLoadingPluginStates())
        pluginsStateMachine.startStatesInvocation()
    }

    func loadPluginsGroup(_ successHandler: @escaping StateCallBack,
                          _ failHandler: @escaping StateCallBack) {
        let loadingManager = LoadingManager()
        loadingManager.loadFile(type: .plugins) { success in
            success ? successHandler() : failHandler()
        }
    }

    func prepareAnalyticsPlugins(_ successHandler: @escaping StateCallBack,
                                 _ failHandler: @escaping StateCallBack) {
        analytics.prepareManager {
            successHandler()
        }
    }

    func updatePluginSessionStorageData(_ successHandler: @escaping StateCallBack,
                                        _ failHandler: @escaping StateCallBack) {
        func sendConfigurationToSessionStorage(pluginModel: ZPPluginModel) {
            guard let configationJSON = pluginModel.configurationJSON as? [String: String] else {
                successHandler()
                return
            }

            configationJSON.forEach { arg in

                let (key, value) = arg
                _ = FacadeConnector.connector?.storage?.sessionStorageSetValue(for: key,
                                                                                                    value: value,
                                                                                                    namespace: pluginModel.identifier)
            }
        }

        guard let allPluginModels = PluginsManager.allPluginModels else {
            successHandler()
            return
        }

        allPluginModels.forEach { model in
            sendConfigurationToSessionStorage(pluginModel: model)
        }
        successHandler()
    }
}