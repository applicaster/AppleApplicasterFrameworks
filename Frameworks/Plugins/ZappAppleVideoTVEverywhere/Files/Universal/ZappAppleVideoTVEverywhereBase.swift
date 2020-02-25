//
//  ZappAppleVideoTVEverywhereBase.swift
//  ZappGeneralPlugins
//
//  Created by Jesus De Meyer on 24/02/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import AVFoundation
import ZappCore
import VideoSubscriberAccount

struct ItemMetadata {
    static let title = "title"
    static let contentId = "id"
}

struct VSRequestResponse {
    var accountProviderID: String = ""
    var authExpirationDate: Date?
}

class ZappAppleVideoTVEverywhereBase: NSObject, PlayerDependantPluginProtocol, VSAccountManagerDelegate {
    var playerPlugin: PlayerProtocol?
    var playbackStalled: Bool = false

    var avPlayer: AVPlayer? {
        return playerPlugin?.playerObject as? AVPlayer
    }

    public var configurationJSON: NSDictionary?
    public var model: ZPPluginModel?

    fileprivate lazy var vsAccountManager: VSAccountManager = {
        return VSAccountManager()
    }()
    
    public required init(pluginModel: ZPPluginModel) {
        super.init()
        
        model = pluginModel
        configurationJSON = model?.configurationJSON
        
        vsAccountManager.delegate = self
        
        checkStatus(prompt: false) { (result) in
            if result == false {
                self.checkStatus(prompt: true) { (_) in
                    
                }
            }
        }
    }

    public var providerName: String {
        return "Apple TV Everywhere"
    }

    public func prepareProvider(_ defaultParams: [String: Any],
                                completion: ((_ isReady: Bool) -> Void)?) {
        completion?(true)
    }

    public func disable(completion: ((Bool) -> Void)?) {
        completion?(true)
    }
    
    // MARK: - VideoSubscriber utilities
    
    func checkStatus(prompt: Bool, _ completion: @escaping (_ result: Bool) -> Void) {
        vsAccountManager.checkAccessStatus(options: [VSCheckAccessOption.prompt : prompt]) { (status, error) in
            completion(status == .granted)
        }
    }
    
    func checkAuthStatus(_ completion : @escaping (_ response: VSRequestResponse?, _ error: VSError?) -> Void) {
        let request = VSAccountMetadataRequest()
        request.includeAccountProviderIdentifier = true
        request.includeAuthenticationExpirationDate = true
        request.isInterruptionAllowed = false
        
        vsAccountManager.enqueue(request) { (userMetadata, error) in
            if let metadata = userMetadata {
                let response = VSRequestResponse(accountProviderID: metadata.accountProviderIdentifier ?? "", authExpirationDate: metadata.authenticationExpirationDate)
                completion(response, error as? VSError)
            } else {
                completion(nil, error as? VSError)
            }
        }
    }
    
    func requestDeviceAuthenticationIfNotAuthenticated() {
        let request = VSAccountMetadataRequest()
        request.includeAccountProviderIdentifier = true
        request.includeAuthenticationExpirationDate = true
        request.isInterruptionAllowed = true
        
        vsAccountManager.enqueue(request) { (userMetadata, error) in
            //print(userMetadata)
            //userMetadata?.samlAttributeQueryResponse
            
        }
    }
    
    func requestAppLevelAuthentication() {
        let request = VSAccountMetadataRequest()
        //request.verificationToken = token
        //request.channelIdentifier = channelIdentifier
        request.isInterruptionAllowed = true
        //request.attributeNames = requestedAttributes
        
        vsAccountManager.enqueue(request) { (userMetadata, error) in
             print(userMetadata)
        }
    }
    
    // MARK: - VideoSubscriberAccount delegate
    
    func accountManager(_ accountManager: VSAccountManager, present viewController: UIViewController) {
        if let topVC = getTopViewController() {
            topVC.present(viewController, animated: true, completion: nil)
        }
    }
    
    func accountManager(_ accountManager: VSAccountManager, dismiss viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func accountManager(_ accountManager: VSAccountManager, shouldAuthenticateAccountProviderWithIdentifier accountProviderIdentifier: String) -> Bool {
        return true
    }
    
    fileprivate func getTopViewController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow else {
            return nil
        }
        
        guard let rootViewController = window.rootViewController else {
            return nil
        }
        
        var childVC = rootViewController
        
        while childVC.presentedViewController != nil {
            childVC = childVC.presentedViewController!
        }
        
        return childVC
    }
}
