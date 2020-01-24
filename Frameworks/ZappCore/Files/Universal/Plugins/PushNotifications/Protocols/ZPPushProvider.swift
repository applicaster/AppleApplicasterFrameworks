//
//  ZPPushProvider.swift
//  ZappPlugins
//
//  Created by Miri on 23/11/2016.
//
//

import UIKit
// import ZappPlugins

@objc open class ZPPushProvider: NSObject, ZPPushProviderProtocol {
    public var providerName: String {
        return getKey()
    }

    public func prepareProvider(_ defaultParams: [String: Any],
                                completion: (Bool) -> Void) {
        guard configureProvider() == true else {
            completion(false)
            return
        }
        defaultParams.forEach { dictionary in
            guard let value = dictionary.value as? NSObject else {
                return
            }
            setBaseParameter(value, forKey: dictionary.key)
        }
        completion(true)
    }

    open var providerProperties: [String: NSObject]!
    open var baseProperties: [String: NSObject] = [String: NSObject]()

    open var configurationJSON: NSDictionary?
    open var providerKey: String {
        return getKey()
    }

    public required init(configurationJSON: NSDictionary?) {
        super.init()
        self.configurationJSON = configurationJSON
    }

    public required override init() {
        super.init()
    }

    open func getKey() -> String {
        // implement in child classes
        return ""
    }

    open func setBaseParameter(_ value: NSObject?,
                               forKey key: String) {
        if let value = value {
            baseProperties[key] = value
        }
    }

    open func configureProvider() -> Bool {
        // implement in child classes
        return false
    }
}
