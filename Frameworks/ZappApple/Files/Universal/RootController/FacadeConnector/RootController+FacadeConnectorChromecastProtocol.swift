//
//  RootController+FacadeConnectorChromecastProtocol.swift
//  ZappApple
//
//  Created by Alex Zchut on 13/04/2020.
//

import Foundation
import ZappCore

extension RootController: FacadeConnectorChromecastProtocol {
    public var isSynced: Bool {
        return false
    }
    
    public var isReachableViaWiFi: Bool {
        return false
    }
    
    public var canShowPlayerBeforeCastSync: Bool {
        return false
    }
    
    public var extendedPlayerViewController: UIViewController? {
        return nil
    }
    
    public var inlinePlayerViewController: UIViewController? {
        return nil
    }
    
    public var miniPlayerViewController: UIViewController? {
        return nil
    }
    
    public func play(with playableItems: [NSObject], currentPosition: TimeInterval) {
        
    }
    
    public func showExtendedPlayer() {
        
    }
    
    public func setNotificationsDelegate(_ delegate: NSObject?) {
        
    }
    
    fileprivate var pluginInstance: ChromecastProtocol? {
        guard let chromecastPlugin = FacadeConnector.connector?.pluginManager?.getProviderInstance(pluginType: ZPPluginType.General.rawValue,
                                                                                                   conformsTo: { $0 as? ChromecastProtocol.Type }) else {
                return nil
        }
        return chromecastPlugin as? ChromecastProtocol
    }
}
