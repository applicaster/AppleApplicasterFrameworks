//
//  ZPDependablePlayerAdDelegatePluginProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 7/22/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

public struct ZPDependablePlayerAdDelegatePluginProtocolKeys {
    static public let playingKey = "advertismentPlaying"
}

/// Delegation that Video ads plugin pass data about ad
@objc public protocol ZPDependablePlayerAdDelegatePluginProtocol:NSObjectProtocol {
    
    /// Video Ad will be presented
    ///
    /// - Parameter provider: instance of ZPPlayerDependantPluginProtocol that will present ad
    func advertisementWillPresented(provider:ZPPlayerDependantPluginProtocol)
    
    /// Video Ad will be removed
    ///
    /// - Parameter provider: instance of ZPPlayerDependantPluginProtocol that will present ad
    func advertisementWillDismissed(provider:ZPPlayerDependantPluginProtocol)
    
    /// Video Ad failed to load
    ///
    /// - Parameter provider: instance of ZPPlayerDependantPluginProtocol that will present ad
    func advertisementFailedToLoad(provider:ZPPlayerDependantPluginProtocol)
}
