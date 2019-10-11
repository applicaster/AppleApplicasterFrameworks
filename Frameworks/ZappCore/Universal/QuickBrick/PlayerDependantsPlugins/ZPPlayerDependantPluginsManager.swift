//
//  ZPPlayerDependantPluginsManager.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 7/17/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation

@objc public class ZPPlayerDependantPluginsManager: NSObject {
    @objc public static let sharedInstance = ZPPlayerDependantPluginsManager()
    
    /// List of registered providers for player Plugins
    static var providers:[String:[ZPPlayerDependantPluginProtocol]] = [:]
    
    private override init() {
        //This prevents others from using the default '()' initializer for this class.
    }
    
    /// Unregister dependants plugins
    ///
    /// - Parameter playerPlugin: Player plugin that conform ZPDependablePlayerPluginProtocol that uses dependant plugins
    @objc public class func unRegisterProviders(playerPlugin:QBPlayerProtocol) {
        providers["\(playerPlugin.hash)"] = nil
        
    }
    
    /// Retrieve list provider for plugin
    ///
    /// - Parameter playerPlugin: Player plugin that conform ZPDependablePlayerPluginProtocol that uses dependant plugins
    /// - Returns: Array of instances of the dependant providers that are conforming ZPPlayerDependantPluginProtocol protocol
    @objc public class func providers(playerPlugin: QBPlayerProtocol) -> [ZPPlayerDependantPluginProtocol]? {
        return providers["\(playerPlugin.hash)"]
    }
}

