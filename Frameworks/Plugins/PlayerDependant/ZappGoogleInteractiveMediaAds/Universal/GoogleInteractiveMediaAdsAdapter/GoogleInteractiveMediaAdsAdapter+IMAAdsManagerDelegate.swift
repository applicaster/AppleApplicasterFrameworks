//
//  GoogleInteractiveMediaAdsAdapter+IMAAdsManagerDelegate.swift
//  GoogleInteractiveMediaAdsTvOS
//
//  Created by Anton Kononenko on 7/25/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import AVFoundation
import GoogleInteractiveMediaAds;
import ZappCore

extension GoogleInteractiveMediaAdsAdapter:IMAAdsManagerDelegate {
    var delegate:DependablePlayerAdDelegatePluginProtocol? {
        return playerPlugin as? DependablePlayerAdDelegatePluginProtocol
    }
    
    public func adsManager(_ adsManager: IMAAdsManager?, didReceive event: IMAAdEvent?) {
        if event?.type == IMAAdEventType.LOADED {
            // When the SDK notifies us that ads have been loaded, play them.
            adsManager?.start()
        }
    }
    
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        delegate?.advertisementWillPresented(provider: self)
        // The SDK is going to play ads, so pause the content.
        playerPlugin?.pluggablePlayerPause()
    }
    
    public func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        delegate?.advertisementFailedToLoad(provider: self)
        // Something went wrong with the ads manager after ads were loaded. Log the error and play the
        // content.
        if let completion = postrollCompletion {
            completion(true)
            postrollCompletion = nil
            adsLoader?.contentComplete()
        } else {
            playerPlugin?.pluggablePlayerResume()
        }
    }
    
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        delegate?.advertisementWillDismissed(provider: self)
        // The SDK is done playing ads (at least for now), so resume the content.
        if let completion = postrollCompletion {
            completion(true)
            postrollCompletion = nil
            adsLoader?.contentComplete()
        }  else {
            playerPlugin?.pluggablePlayerResume()
        }
    }
}
