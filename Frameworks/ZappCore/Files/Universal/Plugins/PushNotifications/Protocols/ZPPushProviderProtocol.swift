//
//  ZPPushProviderProtocol.swift
//  Pods
//
//  Created by Miri on 23/11/2016.
//
//

import Foundation

@objc public protocol ZPPushProviderProtocol: PushProviderProtocol {

    /**
     add base parameters
     */
    func setBaseParameter(_ value:NSObject?,
                          forKey key:String)

    /**
     configure provider
     */
    func configureProvider() -> Bool
    
    /**
     get the provider key
     */
    func getKey() -> String
    
}
