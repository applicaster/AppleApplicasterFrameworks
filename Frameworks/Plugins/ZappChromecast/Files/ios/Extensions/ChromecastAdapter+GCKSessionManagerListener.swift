//
//  ChromecastAdapter+GCKSessionManagerListener.swift
//  ZappChromecast
//
//  Created by Alex Zchut on 4/12/2020
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import GoogleCast
import ZappCore

extension ChromecastAdapter: GCKSessionManagerListener {

    public func sessionManager(_ sessionManager: GCKSessionManager, willStart session: GCKSession) {
        //Send that the session did started notifecation
        NotificationCenter.default.post(name: .chromecastSessionWillStart, object: nil)
        
        //Close dialog screen
        castViewExtender?.dismissDialog()
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager,
                               didStart session: GCKSession) {
        //Send that the session did started notifecation
        NotificationCenter.default.post(name: .chromecastSessionDidStart, object: nil)
    }
    
    public func sessionManager(_ sessionManager: GCKSessionManager,
                               didStart session: GCKCastSession) {
        self.castSession = session

        //What the "Icon Location" was that the tap which lead to the casting came from.
        self.triggerdChromecastButton = self.lastActiveChromecastButton

        //Send event on start casting
        if let triggerdChromecastButton = self.triggerdChromecastButton {
            ChromecastAnalytics.sendStartCastingEvent(triggerdChromecastButton: triggerdChromecastButton)
        }

        //Send that the session did started notifecation
        NotificationCenter.default.post(name: .chromecastCastSessionDidStart, object: nil)
    }

    public func sessionManager(_ sessionManager: GCKSessionManager,
                               willEnd session: GCKSession) {

        //Send event on stop casting
        if let triggerdChromecastButton = self.triggerdChromecastButton {
            ChromecastAnalytics.sendStopCastingEvent(triggerdChromecastButton: triggerdChromecastButton)
        }
        
        //Send that the session did started notifecation
        var streamInfo: [String: Any] = [:]
        if let streamPosition = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient?.mediaStatus?.streamPosition {
            //The current stream position, as an NSTimeInterval from the start of the stream.
            streamInfo["streamPosition"] = streamPosition
        }

        NotificationCenter.default.post(name: .chromecastSessionWillEnd, object: streamInfo)
    }

    public func sessionManager(_ sessionManager: GCKSessionManager,
                               didEnd session: GCKSession,
                               withError error: Error?) {

        self.castSession = nil

        //uninstall  mini player container
        self.updateVisibilityOfMiniPlayerViewController(needUpdateAppearance: true) {
            //do nothing on completion
        }
        
        //Close dialog screen
        castViewExtender?.dismissDialog()
        
        //Send that the session did end notifecation
        NotificationCenter.default.post(name: .chromecastSessionDidEnd, object: nil)
    }

}
