//
//  ReactNativeCommunicationModule.swift
//  ZappTvOS
//
//  Created by François Roland on 20/11/2018.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation
import React
import os.log
import ZappPlugins

let kQuickBrickCommunicationModule = "QuickBrickCommunicationModule"

/**
 Events Supported by the QuickBrickManager native module
 In order to add events, add a case, and add the invoke the appropriate handler in the invokeHandler method
 */
enum Events: String {
    case quickBrickReady = "quickBrickReady"
    case moveAppToBackground = "moveAppToBackground"
    
    /**
     invokes the event handler for a given event
     - parameter manager: instance of the native module on which the event handler should be invoked
     - parameter payload: dictionary of options to pass to the event handler
     */
    func invokeHandler(manager: QuickBrickManagerDelegate, payload: Dictionary<String, Any>) {
        switch self {
        case .quickBrickReady:
            manager.setQuickBrickReady()
        case .moveAppToBackground:
            manager.moveAppToBackground()
        }
        
        
    }
}

/// Delegate Protocol for the QuickBrickManager native module
@objc protocol QuickBrickManagerDelegate {
    /// tells the delegate that the Quick Brick app is ready to be displayed
    func setQuickBrickReady()

    /// Force move application to background
    func moveAppToBackground()
}

@objc(QuickBrickCommunicationModule)
class ReactNativeCommunicationModule: NSObject, RCTBridgeModule {
    var delegateManager: QuickBrickManagerDelegate? {
        return self.bridge?.delegate as? QuickBrickManagerDelegate
    }
    
    /// main React bridge
    public var bridge: RCTBridge?
    
    
    static func moduleName() -> String! {
        return kQuickBrickCommunicationModule
    }
    
    public class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    /// prefered thread on which to run this native module
    @objc public var methodQueue: DispatchQueue {
        return DispatchQueue.main
    }
    
    @objc public func constantsToExport() -> [AnyHashable : Any]! {
        return ReactNativeManager.applicationData
    }

    /**
     bridged method exposed to the js code to allow the js code to send an event to the native code
     - parameter eventName: name of the event to be fired - should match a case of the Events enum, otherwise leads to a noop
     - parameter payload: optional dictionary of properties to pass to the event handler
     */
    @objc func quickBrickEvent(_ eventName: String, payload: [String:Any]?) {
        let event = Events(rawValue: eventName)
        
        guard event != nil, let delegateManager = delegateManager else {
            _ = OSLog(subsystem: "QUICK_BRICK:: unknown manager event called: " + eventName, category: kQuickBrickCommunicationModule)
            return
        }
        
        event?.invokeHandler(manager: delegateManager, payload: payload ?? [:])
    }
}
