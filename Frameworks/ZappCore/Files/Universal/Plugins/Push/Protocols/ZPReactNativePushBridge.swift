//
//  ZPReactNativePushBridge.swift
//  ZappReactNativeAdapter
//
//  Created by Pablo Rueda on 27/06/2018.
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import Foundation
import React
import ZappPlugins

@objc (PushNotifications)
class ZPReactNativePushBridge: NSObject, RCTBridgeModule {
    
    let addTagsErrorCode = "error_add_tags"
    let removeTagsErrorCode = "error_remove_tags"
    let getTagsErrorCode = "error_get_tags"
    
    var bridge: RCTBridge!
    
    var pushProviders: [ZPPushProviderProtocol]
    
    static func moduleName() -> String! {
        return "Push"
    }
    
    init(pushProviders: [ZPPushProviderProtocol]) {
        self.pushProviders = pushProviders
        super.init()
    }
    
    public required override init() {
        self.pushProviders = ZAAppConnector.sharedInstance().pluginsDelegate?.pushNotificationsPluginsManager?.getProviders() ?? []
        super.init()
    }
    
    //MARK: RC extern methods
    
    /// Subscribe the push provider with the tags passed as parameters
    ///
    /// - Parameters:
    ///   - tags: tags to subscribe
    ///   - resolver: resolver when everything succeed
    ///   - rejecter: rejecter when something fails
    @objc func registerTags(_ tags: [String],
                     resolver: @escaping RCTPromiseResolveBlock,
                     rejecter: @escaping RCTPromiseRejectBlock) -> Void {
        guard let pushProvider = pushProviders.first,
            pushProvider.responds(to: #selector(ZPPushProviderProtocol.addTagsToDevice(_:completion:))) else {
            return rejecter(addTagsErrorCode, "The tags couldn't be registered. Please check that the tags don't exist already.", nil)
        }
        
        pushProvider.addTagsToDevice?(tags) { (success, tags) in
            if success {
                resolver(true)
            }else {
                rejecter(self.addTagsErrorCode, "The tags couldn't be registered. Please check that the tags don't exist already.", nil)
            }
        }
    }
    
    /// Remove the tags from the push provider
    ///
    /// - Parameters:
    ///   - tags: tags to remove
    ///   - resolver: resolver when everything succeed
    ///   - rejecter: rejecter when something fails
    @objc func unregisterTags(_ tags: [String],
                       resolver: @escaping RCTPromiseResolveBlock,
                       rejecter: @escaping RCTPromiseRejectBlock) -> Void {
        guard let pushProvider = pushProviders.first,
            pushProvider.responds(to: #selector(ZPPushProviderProtocol.removeTagsToDevice(_:completion:))) else {
            return rejecter(removeTagsErrorCode, "The tags couldn't be unregistered. Please check that the tags exist.", nil)
        }
        
        pushProvider.removeTagsToDevice?(tags) { (success, tags) in
            if success {
                resolver(true)
            }else {
                rejecter(self.removeTagsErrorCode, "The tags couldn't be unregistered. Please check that the tags exist.", nil)
            }
        }
    }
    
    /// Get the tags which the push provider has been suscribed to
    ///
    /// - Parameters:
    ///   - resolver: resolver when everything succeed
    ///   - rejecter: rejecter when something fails
    @objc func getRegisteredTags(_ resolver: @escaping RCTPromiseResolveBlock,
                       rejecter: @escaping RCTPromiseRejectBlock) -> Void {
        guard let pushProvider = pushProviders.first,
            pushProvider.responds(to: #selector(ZPPushProviderProtocol.addTagsToDevice(_:completion:))) else {
                return rejecter(addTagsErrorCode, "Error getting registered tags", nil)
        }
        
        let tags = pushProvider.getDeviceTags?()
        resolver(tags)
    }
}
