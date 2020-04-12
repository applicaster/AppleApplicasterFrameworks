//
//  ChromecastPlayableItem.swift
//  ZappChromecast
//
//  Created by Alex Zchut on 4/12/2020
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation

public class ChromecastPlayableItem: NSObject {
    struct Metadata {
        static let title = "title"
        static let contentId = "id"
        static let media_group = "media_group"
        static let media_item = "media_item"
        static let summary = "summary"
        static let duration = "duration"
        static let src = "src"
        static let key = "key"
        static let image_base = "image_base"
        static let chromecast_poster = "chromecast_poster"
        static let extensions = "extensions"
        static let extensions_is_live = "is_live"
        static let extensions_analytics_extra_params = "analytics_extra_params"
        static let extensions_analytics_custom_params = "analyticsCustomProperties"

    }
    
    public var entry: [String: Any]?

    init(entry: [String: Any]?) {
        super.init()
        self.entry = entry
    }
    
    lazy public var title: String? = {
        return entry?[Metadata.title] as? String
    }()
    
    lazy public var contentId: String? = {
        return entry?[Metadata.contentId] as? String
    }()
    
    lazy public var summary: String? = {
        return entry?[Metadata.summary] as? String
    }()
    
    lazy public var duration: TimeInterval = {
        return entry?[Metadata.duration] as? TimeInterval ?? 0.00
    }()
    
    lazy public var src: String? = {
        return entry?[Metadata.src] as? String
    }()
    
    lazy public var extensions:  [String: Any]? = {
        return entry?[Metadata.extensions] as? [String: Any]
    }()
    
    lazy public var analytics_extra_params: NSDictionary? = {
        return entry?[Metadata.extensions_analytics_extra_params] as? NSDictionary
    }()
    
    lazy public var analytics_custom_params: NSDictionary? = {
        return entry?[Metadata.extensions_analytics_custom_params] as? NSDictionary
    }()

    lazy public var isLive: Bool = {
        guard let value = extensions?[Metadata.extensions_is_live] as? Bool else {
            return false
        }
        return value
    }()
    
    
    
    lazy public var defaultImageUrl: String? = {
        var value: String?
        if let mediaGroup = entry?[Metadata.media_group] as? [[AnyHashable: Any]],
            let mediaItem = mediaGroup.first?[Metadata.media_item] as? [[AnyHashable: Any]],
            let src = mediaItem.first?[Metadata.src] as? String,
            let key = mediaItem.first?[Metadata.key] as? String, key == Metadata.image_base {
            
            value = src
        }
        return value
    }()
    
    lazy public var chromecastPosterImageUrl: String? = {
        var value: String?
        if let mediaGroup = entry?[Metadata.media_group] as? [[AnyHashable: Any]],
            let mediaItem = mediaGroup.first?[Metadata.media_item] as? [[AnyHashable: Any]],
            let src = mediaItem.first?[Metadata.src] as? String,
            let key = mediaItem.first?[Metadata.key] as? String, key == Metadata.chromecast_poster {

            value = src
        }
        return value
    }()
}
