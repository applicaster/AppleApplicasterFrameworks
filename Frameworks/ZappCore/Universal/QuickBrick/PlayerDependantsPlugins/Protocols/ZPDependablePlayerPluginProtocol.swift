//
//  ZPDependablePlayerPluginProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 7/22/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation
import AVKit

/// Currently availible types of dependant plugins
public struct ZPVideoDependantPlugins {
    public static let VideoAdvertisement = ZappPluginType.VideoAdvertisement.rawValue
}

/// Player that wants to use Dependant Player plugins my implement this protocol
@objc public protocol ZPDependablePlayerPluginProtocol{
    
    /// Dependant plugins that avalible for this player pluging
    /// Note: Use list from `ZPVideoDependantPlugins`
    var supportedDependantPluginType:[String] { get }
}
