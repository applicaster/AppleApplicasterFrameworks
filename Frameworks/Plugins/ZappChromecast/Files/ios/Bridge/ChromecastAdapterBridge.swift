//
//  ChromecastAdapterBridge.swift
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 29/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import React
import ZappCore

@objc(ChromecastButton)
public class ChromecastButton: RCTViewManager {
    static let chromecastModuleName = "ChromecastButton"
    let pluginIdentifier = "zapp_generic_cromecast"

    override public static func moduleName() -> String? {
        return ChromecastButton.chromecastModuleName
    }
    
    override public class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override open var methodQueue: DispatchQueue {
        return bridge.uiManager.methodQueue
    }
    
    override public func view() -> UIView? {
        guard let _ = bridge?.eventDispatcher(),
            let chromecastPlugin = FacadeConnector.connector?.pluginManager?.getProviderInstance(identifier: pluginIdentifier) as? ChromecastAdapter else {
            return nil
        }
        
        let container = ChromecastButtonContainer()
        chromecastPlugin.addButton(to: container,
                                   key: container.key,
                                   color: container.color)
        return container
    }
    
}
