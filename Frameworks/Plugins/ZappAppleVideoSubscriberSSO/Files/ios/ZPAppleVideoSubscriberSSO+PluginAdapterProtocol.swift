//
//  ZPAppleVideoNowPlayingInfo+Observers.swift
//  ZappAppleVideoSubscriberSSO
//
//  Created by Alex Zchut on 22/03/2020.
//

import Foundation
import ZappCore

extension ZPAppleVideoSubscriberSSO: PluginAdapterProtocol {
    public var providerName: String {
        return "Apple Video Subscriber SSO"
    }
    
    public func prepareProvider(_ defaultParams: [String : Any], completion: ((Bool) -> Void)?) {
        
        completion?(true)
    }
    
    public func disable(completion: ((Bool) -> Void)?) {
        completion?(true)
    }
}
