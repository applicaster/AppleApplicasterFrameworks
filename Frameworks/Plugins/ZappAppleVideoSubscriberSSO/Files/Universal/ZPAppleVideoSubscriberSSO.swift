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
    
    lazy var vsAuthorizationEndpoint: String? = {
        guard let endpoint = configurationJSON?["authorization_endpoint"] as? String,
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
    
    func performPrehook(_ completion: @escaping (_ success: Bool) -> Void) {
        self.vsaAccessOperationCompletion = completion
        
        self.askForAccessIfNeeded(prompt: false) { (status) in
            //update authorization status
            self.managerInfo.isAuthorized = status
        
            if self.managerInfo.isAuthorized {
                self.requestAuthenticationStatus { (authResult, error) in
                    if let authResult = authResult {
                        //update authentication status
                        self.managerInfo.isAuthenticated = authResult.success
                    }
                    self.performApplevelAuthenticationIfNeeded()
                }
            } else {
                self.processResult()
            }
        }
    }
    
    fileprivate func performApplevelAuthenticationIfNeeded() {
        //check and perform app level authentication if required
        if self.vsApplevelAuthenticationEndpoint?.isEmpty == false && self.vsApplevelAuthenticationAttributes.count > 0 {
            //reset authentication status
            self.managerInfo.isAuthenticated = false
            
            self.getVerificationToken { (status, verificationToken, message) in
                if status, let verificationToken = verificationToken {
                    /*
                    Once the customer is authenticated to a TV provider, the next step is to request information from your service provider for the specific app using the customer’s TV provider. This information includes the verificationToken used to authenticate at the app-level and attributesNames in the metadata request. Along with this request, you are required to request at least one attribute.
                    */
                    self.requestAppLevelAuthentication(verificationToken: verificationToken) { (authResult, error) in
                        self.getServiceProviderToken(for: authResult) { (success, token, message) in
                            self.managerInfo.isAuthenticated = success
                            self.processResult()
                        }
                    }
                }
                else {
                    self.processResult()
                }
            }
        }
        else {
            self.processResult()
        }
    }
    
    fileprivate func processResult() {
        let success = self.managerInfo.isAuthorized && self.managerInfo.isAuthenticated
        DispatchQueue.main.async {
            self.vsaAccessOperationCompletion?(success)
        }
    }
}
