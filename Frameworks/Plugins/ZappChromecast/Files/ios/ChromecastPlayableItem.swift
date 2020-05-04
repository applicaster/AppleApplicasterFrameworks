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
        static let image_base = "image_base"
        static let chromecast_poster = "chromecast_poster"
        static let summary = "summary"
        static let duration = "extensions.duration"
        static let content_src = "content.src"
        static let content_type = "content.type"
        static let key = "key"
        static let src = "src"
        static let type = "type"
        static let is_live = "extensions.is_live"
        static let analytics = "analytics"
        static let extensions_analytics_extra_params = "extensions.analytics_extra_params"
        static let extensions_analytics_custom_params = "extensions.analyticsCustomProperties"

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
        return entry?.getValue(forKeyPath: Metadata.duration) as? TimeInterval ?? 0.00
    }()
    
    lazy public var src: String? = {
        return entry?.getValue(forKeyPath: Metadata.content_src) as? String
    }()
    
    lazy public var contentType: String? = {
        return entry?.getValue(forKeyPath: Metadata.content_type) as? String
    }()
    
    lazy public var analytics: NSDictionary? = {
        return entry?[Metadata.analytics] as? NSDictionary
    }()

    lazy public var isLive: Bool = {
        guard let value = entry?.getValue(forKeyPath: Metadata.is_live) as? Bool else {
            return false
        }
        return value
    }()
    
    lazy public var defaultImageUrl: String? = {
        var value: String?
        if let mediaGroups = entry?[Metadata.media_group] as? [[AnyHashable: Any]] {
            let mediaGroup = mediaGroups.first { (group) -> Bool in
                guard let type = group.getValue(forKeyPath: Metadata.type) as? String,
                    type == "image" else {
                        return false
                }
                return true
            }
            
            if let mediaItems = mediaGroup?[Metadata.media_item] as? [[AnyHashable: Any]] {
                let mediaItem = mediaItems.first { (item) -> Bool in
                    guard let key = item.getValue(forKeyPath: Metadata.key) as? String,
                        key == Metadata.image_base else {
                            return false
                    }
                    return true
                }
                value = mediaItem?.getValue(forKeyPath: Metadata.src) as? String
            }
        }
        
        return value
    }()
    
    lazy public var chromecastPosterImageUrl: String? = {
        var value: String?
        if let mediaGroups = entry?[Metadata.media_group] as? [[AnyHashable: Any]] {
            let mediaGroup = mediaGroups.first { (group) -> Bool in
                guard let type = group.getValue(forKeyPath: Metadata.type) as? String,
                    type == "image" else {
                        return false
                }
                return true
            }
            
            if let mediaItems = mediaGroup?[Metadata.media_item] as? [[AnyHashable: Any]] {
                let mediaItem = mediaItems.first { (item) -> Bool in
                    guard let key = item.getValue(forKeyPath: Metadata.key) as? String,
                        key == Metadata.chromecast_poster else {
                            return false
                    }
                    return true
                }
                value = mediaItem?.getValue(forKeyPath: Metadata.src) as? String
            }
        }
        
        return value
    }()
    
    lazy public var analytics_extra_params: NSDictionary? = {
        return entry?.getValue(forKeyPath: Metadata.extensions_analytics_extra_params) as? NSDictionary
    }()
    
    lazy public var analytics_custom_params: NSDictionary? = {
        return entry?.getValue(forKeyPath: Metadata.extensions_analytics_custom_params) as? NSDictionary
    }()
}

extension Dictionary {
    func getValue(forKeyPath path:String) -> Any? {
        guard let dict = self as? [String: Any] else {
            return nil
        }
        return getDictValue(dict: dict, path: path)
    }
    
    func getDictValue(dict:[String: Any], path:String)->Any?{
        let arr = path.components(separatedBy: ".")
        if(arr.count == 1){
            return dict[String(arr[0])]
        }
        else if (arr.count > 1){
            let p = arr[1...arr.count-1].joined(separator: ".")
            let d = dict[String(arr[0])] as? [String: Any]
            if (d != nil){
                return getDictValue(dict:d!, path:p)
            }
        }
        return nil
    }
}
