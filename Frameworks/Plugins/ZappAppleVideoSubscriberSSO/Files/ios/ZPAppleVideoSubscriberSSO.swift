//
//  ZPAppleVideoSubscriberSSO.swift
//  ZappAppleVideoSubscriberSSO for iOS
//
//  Created by Alex Zchut on 22/03/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import ZappCore
import VideoSubscriberAccount

struct VideoSubscriberAccountManagerInfo {
    var isAuthorized: Bool = false // do we have access to the framework?
    var isAuthenticated: Bool = false // are we logged in?
}

struct VideoSubscriberAccountManagerResult {
    var accountProviderID: String?
    var authExpirationDate: Date?
    var verificationData: Data?
        
    static func createFromMetadata(_ metadata: VSAccountMetadata) -> VideoSubscriberAccountManagerResult {
        var result = VideoSubscriberAccountManagerResult()
        
        result.accountProviderID = metadata.accountProviderIdentifier
        result.authExpirationDate = metadata.authenticationExpirationDate
        result.verificationData = metadata.verificationData
        
        return result
    }
}

class ZPAppleVideoSubscriberSSO: NSObject {
    var playerPlugin: PlayerProtocol?
    var configurationJSON: NSDictionary?
    var model: ZPPluginModel?
    var managerInfo = VideoSubscriberAccountManagerInfo()
    var vsaAccessOperationCompletion:((_ success: Bool) -> Void)?
    
    lazy var videoSubscriberAccountManager: VSAccountManager = {
        return VSAccountManager()
    }()
    
    lazy var verificationToken: String? = {
        guard let token = configurationJSON?["verification_token"] as? String,
            !token.isEmpty else {
                return nil
        }
        return token
    }()
    
    lazy var channelIdentifier: String? = {
        guard let identifier = configurationJSON?["channel_identifier"] as? String,
            !identifier.isEmpty else {
                return nil
        }
        return identifier
    }()
    
    lazy var attributeNames: [String] = {
        guard let names = configurationJSON?["attribute_names"] as? String,
            !names.isEmpty else {
            return []
        }
        return names.components(separatedBy: ",")
    }()
    
    
    required init(pluginModel: ZPPluginModel) {
        super.init()
        model = pluginModel
        configurationJSON = model?.configurationJSON
        
        videoSubscriberAccountManager.delegate = self
    }
}
