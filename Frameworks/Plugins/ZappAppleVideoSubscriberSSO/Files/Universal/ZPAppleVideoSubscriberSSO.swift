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
    
    lazy var videoSubscriberAccountManager: VSAccountManager = {
        return VSAccountManager()
    }()
    
    lazy var providerIdentifier: String = {
        guard let value = configurationJSON?["provider_identifier"] as? String,
            !value.isEmpty else {
                return ""
        }
        return value
    }()
    
    required init(pluginModel: ZPPluginModel) {
        super.init()
        model = pluginModel
        configurationJSON = model?.configurationJSON
        
        videoSubscriberAccountManager.delegate = self
    }
}
