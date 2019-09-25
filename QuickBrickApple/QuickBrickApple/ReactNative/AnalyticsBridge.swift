//
//  AnalyticsBridge.swift
//  ZappTvOS
//
//  Created by François Roland on 22/11/2018.
//  Copyright © 2018 Anton Kononenko. All rights reserved.
//

import Foundation
import React
import ZappPlugins

@objc(AnalyticsBridge)
class AnalyticsBridge: NSObject, RCTBridgeModule {
    static func moduleName() -> String! {
        return "AnalyticsBridge"
    }
    
    public class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    /// prefered thread on which to run this native module
    @objc public var methodQueue: DispatchQueue {
        return DispatchQueue.main
    }
    
    @objc func postEvent(_ eventName: String, payload: [String: Any]?) {
        ZAAppConnector.sharedInstance().analyticsDelegate?.trackEvent(name: eventName, parameters: payload ?? [:])
    }
    
    @objc func postTimedEvent(_ eventName: String, payload: [String: Any]?) {
        ZAAppConnector.sharedInstance().analyticsDelegate?.trackEvent(name: eventName,
                                                                      parameters: payload,
                                                                      timed: true)
    }
    
    @objc func endTimedEvent(_ eventName: String, payload: [String: Any]?) {
        ZAAppConnector.sharedInstance().analyticsDelegate?.endTimedEvent(eventName,
                                                                         withParameters: payload)
    }
}
