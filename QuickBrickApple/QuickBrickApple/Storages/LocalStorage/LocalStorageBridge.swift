//
//  LocalStorageBridge.swift
//  ZappTvOS
//
//  Created by Anton Kononenko on 5/9/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation

import Foundation
import React
import ZappPlugins

@objc (LocalStorage)
class LocalStorageBridge: NSObject, RCTBridgeModule {
    
    var bridge: RCTBridge!
    
    static func moduleName() -> String! {
        return "LocalStorage"
    }
    
    public class func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    //MARK: RC extern methods
    
    /// Store a stringified object in LocalStorage
    ///
    /// - Parameters:
    ///   - key: key name for value
    ///   - value: stringified value
    ///   - namespace: namespace to use when saving values to avoid collisions
    ///   - resolver: resolver when value is saved successfully
    ///   - rejecter: rejecter when something fails
    @objc public func setItem(_ key: String?, value: String?, namespace: String?,
                       resolver: @escaping RCTPromiseResolveBlock,
                       rejecter: @escaping RCTPromiseRejectBlock) -> Void {
        DispatchQueue.main.async {
            guard let key = key, let value = value else {
                rejecter(StorageErrorCallback.errorCode, StorageErrorCallback.errorMessageSet, nil)
                return
            }
            if LocalStorage.sharedInstance.set(key: key, value: value, namespace: namespace) {
                resolver(true)
            } else {
                rejecter(StorageErrorCallback.errorCode, StorageErrorCallback.errorMessageSet, nil)
            }
        }
    }
    
    /// Get previously saved session value by key
    ///
    /// - Parameters:
    ///   - key: key to use for value retrieval
    ///   - namespace: namespace used when saving values
    ///   - resolver: resolver when everything succeed
    ///   - rejecter: rejecter when something fails
    @objc public func getItem(_ key: String?, namespace: String?,
                       resolver: @escaping RCTPromiseResolveBlock,
                       rejecter: @escaping RCTPromiseRejectBlock) -> Void {
        
        DispatchQueue.main.async {
            guard let key = key else {
                rejecter(StorageErrorCallback.errorCode, StorageErrorCallback.errorMessageGet, nil)
                return
            }
            if let retVal = LocalStorage.sharedInstance.get(key: key, namespace: namespace) {
                resolver(retVal)
            } else {
                rejecter(StorageErrorCallback.errorCode, StorageErrorCallback.errorMessageGet, nil)
            }
        }
    }
    
    /// Get ALL previously saved session values
    ///
    /// - Parameters:
    ///   - namespace: namespace used when saving values
    ///   - resolver: resolver when everything succeed
    ///   - rejecter: rejecter when something fails
    @objc public func getAllItems(_ namespace: String?,
                                  resolver: @escaping RCTPromiseResolveBlock,
                                  rejecter: @escaping RCTPromiseRejectBlock) -> Void {
        
        DispatchQueue.main.async {
            if let retVal = LocalStorage.sharedInstance.getAll(namespace: namespace) {
                resolver(retVal)
            } else {
                rejecter(StorageErrorCallback.errorCode, StorageErrorCallback.errorMessageGet, nil)
            }
        }
    }
}
