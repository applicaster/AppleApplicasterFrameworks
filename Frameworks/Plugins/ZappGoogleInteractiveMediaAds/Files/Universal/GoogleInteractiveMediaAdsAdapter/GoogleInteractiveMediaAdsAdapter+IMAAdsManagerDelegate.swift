//
//  GoogleInteractiveMediaAdsAdapter+IMAAdsManagerDelegate.swift
//  GoogleInteractiveMediaAdsTvOS
//
//  Created by Anton Kononenko on 7/25/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import AVFoundation
import Foundation
import GoogleInteractiveMediaAds
import ZappCore

extension GoogleInteractiveMediaAdsAdapter: IMAAdsManagerDelegate {
    var delegate: DependablePlayerAdDelegatePluginProtocol? {
        return playerPlugin as? DependablePlayerAdDelegatePluginProtocol
    }

    public func adsManager(_ adsManager: IMAAdsManager?, didReceive event: IMAAdEvent?) {
        switch event?.type {
        case .LOADED:
            adsManager?.start()
        case .ALL_ADS_COMPLETED:
            if let urlTagData = urlTagData, urlTagData.isVmapAd {
                isVMAPAdsCompleted = true
            }
            postrollCompletion?(true)
        default:
            return
        }
    }

    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        delegate?.advertisementWillPresented(provider: self)
        // The SDK is going to play ads, so pause the content.
  
        isPlaybackPaused = true
        playerPlugin?.pluggablePlayerPause()
    }

    public func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        delegate?.advertisementFailedToLoad(provider: self)
        // Something went wrong with the ads manager after ads were loaded. Log the error and play the
        // content.
        isPlaybackPaused = false
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
        isPlaybackPaused = false
        playerPlugin?.pluggablePlayerResume()
    }
}
