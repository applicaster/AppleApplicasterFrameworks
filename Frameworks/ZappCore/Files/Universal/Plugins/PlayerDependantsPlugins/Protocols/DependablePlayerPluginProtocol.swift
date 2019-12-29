//
//  VideoDependantPlugins.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 7/22/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import AVKit
import Foundation

/// Currently availible types of dependant plugins
public struct VideoDependantPlugins {
    public static let VideoAdvertisement = ZPPluginType.VideoAdvertisement.rawValue
    public static let Analytics = ZPPluginType.Analytics.rawValue
}

/// Player that wants to use Dependant Player plugins my implement this protocol
@objc public protocol DependablePlayerPluginProtocol {
    /// Dependant plugins that avalible for this player pluging
    /// Note: Use list from `VideoDependantPlugins`
    var supportedDependantPluginType: [String] { get }
}
