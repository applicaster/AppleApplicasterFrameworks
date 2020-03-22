//
//  ZPAppleVideoSubscriberSSO.swift
//  ZappAppleVideoSubscriberSSO for iOS
//
//  Created by Alex Zchut on 22/03/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import ZappCore
import VideoSubscriberAccount

class ZPAppleVideoSubscriberSSO: NSObject {

    var playerPlugin: PlayerProtocol?
    var configurationJSON: NSDictionary?
    var model: ZPPluginModel?
    var managerInfo = VideoSubscriberAccountManagerInfo()
    var vsaAccessOperationCompletion:((_ success: Bool) -> Void)?
    let authTokenCharacterSet = CharacterSet(charactersIn: "=\"#%/<>?@\\^`{|}")

    lazy var videoSubscriberAccountManager: VSAccountManager = {
        return VSAccountManager()
    }()
    
    lazy var vsVerificationTokenEndpoint: String? = {
        guard let endpoint = configurationJSON?["verification_token_endpoint"] as? String,
            !endpoint.isEmpty else {
                return nil
        }
        return endpoint
    }()
    
    lazy var vsAuthenticationEndpoint: String? = {
        guard let endpoint = configurationJSON?["authentication_endpoint"] as? String,
            !endpoint.isEmpty else {
                return nil
        }
        return endpoint
    }()
    
    lazy var vsSupportedProviderIdentifiers: [String] = {
        guard let identifiers = configurationJSON?["provider_identifiers"] as? String,
            !identifiers.isEmpty else {
                return []
        }
        return identifiers.components(separatedBy: ",")
    }()
    
    lazy var vsProviderName: String? = {
        guard let identifier = configurationJSON?["provider_name"] as? String,
            !identifier.isEmpty else {
                return nil
        }
        return identifier
    }()
    
    lazy var vsApplevelAuthenticationEndpoint: String? = {
        guard let endpoint = configurationJSON?["app_level_authentication_endpoint"] as? String,
            !endpoint.isEmpty else {
                return nil
        }
        return endpoint
    }()
    
    lazy var vsApplevelAuthenticationAttributes: [String] = {
        guard let attributes = configurationJSON?["app_level_authentication_attributes"] as? String,
            !attributes.isEmpty else {
                return []
        }
        return attributes.components(separatedBy: ",")
    }()
    
    
    
    required init(pluginModel: ZPPluginModel) {
        super.init()
        model = pluginModel
        configurationJSON = model?.configurationJSON
        
        videoSubscriberAccountManager.delegate = self
    }
}
