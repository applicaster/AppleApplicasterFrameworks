//
//  ChromecastAdapter+ZPChromecastProtocol.swift
//  ZappChromecast
//
//  Created by Alex Zchut on 4/12/2020
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import ZappCore
import GoogleCast

extension ChromecastAdapter: ChromecastProtocol {
    
    public var containerViewEventsDelegate: Any? {
        get {
            return localContainerViewEventsDelegate
        }
        set(newValue) {
            localContainerViewEventsDelegate = newValue as? ChromecastNotificationsProtocol
        }
    }

    public var triggerdChromecastButton: ChromecastButtonOrigin? {
        get {
            return localTriggerdChromecastButton
        }
        set(newValue) {
            localTriggerdChromecastButton = newValue
        }
    }

    public var lastActiveChromecastButton: ChromecastButtonOrigin? {
        get {
            return localLastActiveChromecastButton
        }
        set(newValue) {
            localLastActiveChromecastButton = newValue
        }
    }

    public func prepareChromecastForUse() -> Bool {
        guard let chromecastAppId = chromecastAppId else {
            return false
        }
        
        let discoveryCriteria = GCKDiscoveryCriteria(applicationID: chromecastAppId)
        let options = GCKCastOptions(discoveryCriteria: discoveryCriteria)
        
        if GCKCastContext.setSharedInstanceWith(options, error: nil) {
            GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = false
            
            //set logger
            let logFilter: GCKLoggerFilter = GCKLoggerFilter()
            let classes = ["GCKDeviceScanner",
                           "GCKDeviceProvider",
                           "GCKDiscoveryManager",
                           "GCKCastChannel",
                           "GCKMediaControlChannel",
                           "GCKUICastButton",
                           "GCKUIMediaController",
                           "NSMutableDictionary"]
            logFilter.setLoggingLevel(.error, forClasses: classes)
            
            GCKLogger.sharedInstance().filter = logFilter
            GCKLogger.sharedInstance().delegate = self
            
            self.addObservers()
                    
            return true
        } else {
            return false
        }
        
    }

    public func hasConnectedCastSession() -> Bool {
        guard GCKCastContext.isSharedInstanceInitialized() else {
            return false
        }
        
        return GCKCastContext.sharedInstance().sessionManager.hasConnectedCastSession()
    }
    
    public func getConnectedDeviceName() -> String? {
        if !hasConnectedCastSession() {
            return nil
        }
        
        return GCKCastContext.sharedInstance().sessionManager.currentSession?.device.friendlyName
    }

    public func createChromecastButton(frame:CGRect,
                                       customIcons: [String: [UIImage]]?) -> UIButton {

        let castButton = GCKUICastButton(frame: frame)
//        if let customIcons = customIcons,
//            let activeIcon = customIcons[ChromecastButtonIcons.active]?.first,
//            let inactiveIcon = customIcons[ChromecastButtonIcons.inactive]?.first,
//            let animationIcons = customIcons[ChromecastButtonIcons.animation], animationIcons.count == 3 {
//
//            castButton.setInactiveIcon(inactiveIcon,
//                                       activeIcon: activeIcon,
//                                       animationIcons: animationIcons)
//        }

        //Check if the we want handle the chromecast devices dialog window
        //Otherwise, use Google's default devices dialog
        if castViewExtender != nil {
            castButton.triggersDefaultCastDialog = false
            castButton.addTarget(self, action: #selector(showCustomDevicesDialog), for: .touchUpInside)
        }

        return castButton
    }

    public func createChromecastButton(frame:CGRect) -> UIButton {
        return self.createChromecastButton(frame: frame,
                                    customIcons: nil)
    }
    
    public func presentCastInstructionsViewControllerOnce(with castButton:UIButton) {
        
        guard GCKCastContext.isSharedInstanceInitialized() else {
            return
        }
        
        guard let castButton = castButton as? GCKUICastButton else {
            return
        }
        
        GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce(with: castButton)
    }
    
    public func defaultExpandedMediaControlsViewController() -> UIViewController? {
        guard GCKCastContext.isSharedInstanceInitialized() else {
            return nil
        }
        
        return GCKCastContext.sharedInstance().defaultExpandedMediaControlsViewController
    }

    public func getShouldPresentIntroductionScreen() -> Bool {
        return self.shouldPresentIntroductionScreen
    }
    
    @objc func showCustomDevicesDialog(_ sender: UIButton) {
        castViewExtender?.showDialog()
    }
}
