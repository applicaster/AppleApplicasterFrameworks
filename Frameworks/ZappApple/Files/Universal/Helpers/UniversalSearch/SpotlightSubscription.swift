//
//  SpotlightSubscription.swift
//  ZappApple
//
//  Created by Anton Kononenko on 8/12/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//
import Foundation
import CoreSpotlight
import ZappCore

class SpotlightSubscription {
    var universalSearchPlugin:ZPPluginModel?
    
    lazy var isUniversalSearchEnabled:Bool = {
        guard let bundleDict = Bundle.main.infoDictionary,
            let bundleID = bundleDict["UISupportsTVApp"] as? Bool else {
                return false
        }
        return true
    }()
    
    lazy var subscriptionInfo:String = {
        var retVal = ""
        if let bundleDict = Bundle.main.infoDictionary,
            let bundleID = bundleDict[kCFBundleIdentifierKey as String] as? String {
            retVal = bundleID
        }
        return retVal;
    }()
    
    lazy var expirationPeriod:Int = {
        return 1
    }()
    
    lazy var availabilityType:String = {
        return ""
    }()
    
    lazy var tiers:[String] = {
        return []
    }()
    
    lazy var hasNeededEntitlements:Bool = {
        guard isUniversalSearchEnabled == true else {
            return false
        }
        #if DEBUG
        return false
        #else
        return true
        #endif
    }()
    
    var userSubscriptionInfo: String {
        get {
            if !availabilityType.isEmpty && tiers.count > 0 {
                let tiersCombined = tiers.map({"\($0)"}).joined(separator: ",")
                return "{ \"availabilityType\": \"\(availabilityType)\", \"tiers\": [\(tiersCombined)] }"
            }
            else {
                return subscriptionInfo
            }
        }
    }
    
    open func activate() {
        if universalSearchPlugin == nil {
            universalSearchPlugin = PluginsManager.pluginModels()?.first(where: { (plugin) -> Bool in
                return plugin.identifier == "universal_search"
            })
        }
        if self.hasNeededEntitlements,
            let userExpirationDate = Calendar.current.date(byAdding: .month, value: expirationPeriod, to: Date()) {
            
            let subscriptionManager = CSSubscriptionManager.shared()
            subscriptionManager?.registerSubscription(withInfo: userSubscriptionInfo,
                                                      expirationDate: userExpirationDate)
        }
    }
    
    open func deactivate(completion: ((Bool) -> Void)?) {
        if self.hasNeededEntitlements {
            let subscriptionManager = CSSubscriptionManager.shared()
            subscriptionManager?.unregisterSubscription(withInfo: userSubscriptionInfo)
        }
        completion?(true)
    }
    
    open func deactivateAll(completion: ((Bool) -> Void)?) {
        if self.hasNeededEntitlements {
            let subscriptionManager = CSSubscriptionManager.shared()
            subscriptionManager?.unregisterAllSubscriptions()
        }
        completion?(true)
    }
}
