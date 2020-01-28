//
//  ZPPushProvider.swift
//  ZappPlugins
//
//  Created by Miri on 23/11/2016.
//
//

import UIKit

@objc open class ZPPushProvider: NSObject, ZPPushProviderProtocol, PushProviderProtocol {
    public func disable(completion: ((Bool) -> Void)?) {
        
    }
    
    // MARK: PluginAdapterProtocol

    public var model: ZPPluginModel?

    public required init(pluginModel: ZPPluginModel) {
        model = pluginModel
        configurationJSON = pluginModel.configurationJSON
    }

    public func disable(completion: (() -> Void)?) {
        completion?()
    }

    public var providerName: String {
        return getKey()
    }

    public func prepareProvider(_ params: [String: Any],
                                completion: (Bool) -> Void) {
        guard configureProvider() == true else {
            completion(false)
            return
        }
        params.forEach { dictionary in
            guard let value = dictionary.value as? NSObject else {
                return
            }
            setBaseParameter(value, forKey: dictionary.key)
        }
        completion(true)
    }

    // MARK: ZPAdapterPtotocol

    public required init(configurationJSON: NSDictionary?) {
        super.init()
        self.configurationJSON = configurationJSON
    }

    public required override init() {
        super.init()
    }

    open var providerProperties: [String: NSObject]!
    open var baseProperties: [String: NSObject] = [String: NSObject]()

    open var configurationJSON: NSDictionary?
    open var providerKey: String {
        return getKey()
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

