//
//  ImaPluginAdapter.swift
//  ZappTvOS
//
//  Created by Anton Kononenko on 7/17/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
// ZPPlayerDependantPluginProtocol

import AVFoundation
import GoogleInteractiveMediaAds
import UIKit
import ZappCore

@objc public class GoogleInteractiveMediaAdsAdapter: NSObject, PlayerDependantPluginProtocol {
    /// Player plugin instance that currently presented
    public weak var playerPlugin: (PlayerProtocol & DependablePlayerPluginProtocol)?
    var postrollCompletion: ((_ finished: Bool) -> Void)?
    var adRequest: IMAAdsRequest?
    public var configurationJSON: NSDictionary?

    /// Entry point for the SDK. Used to make ad requests.
    internal var adsLoader: IMAAdsLoader?

    /// Playhead used by the SDK to track content video progress and insert mid-rolls.
    internal var contentPlayhead: IMAAVPlayerContentPlayhead?

    /// Main point of interaction with the SDK. Created by the SDK as the result of an ad request.
    internal var adsManager: IMAAdsManager?

    var avPlayer: AVPlayer? {
        return playerPlugin?.playerObject as? AVPlayer
    }

    var urlTagData: GoogleUrlTagData?

    public required override init() {
        super.init()
    }

    public required init(configurationJSON: NSDictionary?) {
        super.init()
        self.configurationJSON = configurationJSON
    }

    var containerView: UIView? {
        guard let playerPlugin = playerPlugin else {
            return nil
        }
        if let playerContainer = playerPlugin.pluginPlayerContainer {
            return playerContainer
        } else if let playerViewController = playerPlugin.pluginPlayerViewController,
            let playerContainer = playerViewController.view {
            return playerContainer
        }
        return nil
    }

    func prepareGoogleIMA() {
        guard let player = avPlayer else { return }
        urlTagData = GoogleUrlTagData(entry: playerPlugin?.entry,
                                      pluginParams: configurationJSON)
        contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player)

        if let urlToPresent = urlTagData?.prerollUrlString() {
            requestAd(adUrl: urlToPresent)
        }
    }

    func setupAdsLoader() {
        let settings = IMASettings()
        settings.enableDebugMode = false
        adsLoader = IMAAdsLoader(settings: settings)
        adsLoader?.delegate = self
    }

    func requestAd(adUrl: String) {
        guard let contentPlayhead = contentPlayhead,
            let containerView = containerView else {
            return
        }
        setupAdsLoader()

        let adDisplayContainer: IMAAdDisplayContainer = IMAAdDisplayContainer(adContainer: containerView,
                                                                              companionSlots: nil)
        if let request = IMAAdsRequest(adTagUrl: adUrl,
                                       adDisplayContainer: adDisplayContainer,
                                       contentPlayhead: contentPlayhead,
                                       userContext: nil) {
            adRequest = request
            adsLoader?.requestAds(with: adRequest)
        }
    }
}
