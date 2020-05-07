//
//  ZPAppleVideoSubscriberSSOBridge.swift
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 31/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import React
import ZappCore

@objc(RNGoogleCast)
class ChromecastManager: NSObject, RCTBridgeModule {
    fileprivate let pluginIdentifier = "chromecast_qb"
    var bridge: RCTBridge!
    var castMediaStartedCompletion: (() -> Void)?
    
    static func moduleName() -> String! {
        return "ChromecastManager"
    }
    
    @objc public func constantsToExport() -> [AnyHashable : Any] {
      return [
        "CAST_STATE_CHANGED": "CAST_STATE_CHANGED",
        "SESSION_STARTING" : "SESSION_STARTING",
        "SESSION_STARTED" : "SESSION_STARTED",
        "SESSION_START_FAILED" : "SESSION_START_FAILED",
        "SESSION_SUSPENDED" : "SESSION_SUSPENDED",
        "SESSION_RESUMING" : "SESSION_RESUMING",
        "SESSION_RESUMED" : "SESSION_RESUMED",
        "SESSION_ENDING" : "SESSION_ENDING",
        "SESSION_ENDED" : "SESSION_ENDED",
        "MEDIA_STATUS_UPDATED" : "MEDIA_STATUS_UPDATED",
        "MEDIA_PLAYBACK_STARTED" : "MEDIA_PLAYBACK_STARTED",
        "MEDIA_PLAYBACK_ENDED" : "MEDIA_PLAYBACK_ENDED",
        "MEDIA_PROGRESS_UPDATED" : "MEDIA_PROGRESS_UPDATED",
        "CHANNEL_CONNECTED" : "CHANNEL_CONNECTED",
        "CHANNEL_MESSAGE_RECEIVED" : "CHANNEL_MESSAGE_RECEIVED",
        "CHANNEL_DISCONNECTED" : "CHANNEL_DISCONNECTED",
        ]
    }
    
    public class func requiresMainQueueSetup() -> Bool {
        return true
    }

    @objc public func play() {
        DispatchQueue.main.async {
            self.pluginInstance?.play()
        }
    }

    @objc public func stop() {
        DispatchQueue.main.async {
            self.pluginInstance?.stop()
        }
    }

    @objc public func pause() {
        DispatchQueue.main.async {
            self.pluginInstance?.pause()
        }
    }

    @objc public func seek(_ playPosition: Int) {
        DispatchQueue.main.async {
            self.pluginInstance?.seek(playPosition)
        }
    }

    @objc public func setVolume(_ volume: CGFloat) {
        DispatchQueue.main.async {
            self.pluginInstance?.setVolume(Float(volume))
        }
    }

    @objc public func showIntroductoryOverlay() {
        DispatchQueue.main.async {
            self.pluginInstance?.presentIntroductionScreenIfNeeded()
        }
    }

    @objc public func launchExpandedControls() {
        DispatchQueue.main.async {
            self.pluginInstance?.presentExtendedPlayerControls()
        }
    }

    @objc public func castMedia(_ params: NSDictionary,
                                resolver: @escaping RCTPromiseResolveBlock,
                                rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let pluginInstance = self.pluginInstance else {
                rejecter("0", "plugin not available", nil)
                return
            }
            
            pluginInstance.prepareToPlay(playableItems: [params], playPosition: 0) {
                resolver(1)
            }
        }
    }

    @objc public func hasConnectedCastSession(_ resolver: @escaping RCTPromiseResolveBlock,
                                              rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let pluginInstance = self.pluginInstance else {
                rejecter("0", "plugin not available", nil)
                return
            }

            resolver(pluginInstance.hasConnectedCastSession())
        }
    }

    @objc public func getCastState(_ resolver: @escaping RCTPromiseResolveBlock,
                                   rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let pluginInstance = self.pluginInstance else {
                rejecter("0", "plugin not available", nil)
                return
            }

            resolver(pluginInstance.getCurrentCastState())
        }
    }

    fileprivate var pluginInstance:ChromecastAdapter? {
        guard let chromecastPlugin = FacadeConnector.connector?.pluginManager?.getProviderInstance(identifier: pluginIdentifier) as? ChromecastAdapter else {
            return nil
        }
        return chromecastPlugin
    }
}
