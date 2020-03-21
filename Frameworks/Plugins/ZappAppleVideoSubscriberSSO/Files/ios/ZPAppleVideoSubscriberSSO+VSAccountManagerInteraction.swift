//
//  ZPAppleVideoSubscriberSSO+VSAccountManagerInteraction.swift
//  ZappAppleVideoSubscriberSSO
//
//  Created by Alex Zchut on 20/03/2020.
//

import VideoSubscriberAccount

extension ZPAppleVideoSubscriberSSO {
    func askForAccessIfNeeded(prompt: Bool, _ completion: @escaping (_ result: Bool) -> Void) {
        self.videoSubscriberAccountManager.checkAccessStatus(options: [VSCheckAccessOption.prompt : NSNumber(booleanLiteral: prompt)]) { (status, error) in
            if prompt {
                self.managerInfo.isAuthorized = status == .granted
                DispatchQueue.main.async {
                    completion(status == .granted)
                }
            } else {
                if status != .granted {
                    self.askForAccessIfNeeded(prompt: true, completion)
                } else {
                    self.managerInfo.isAuthorized = status == .granted
                    DispatchQueue.main.async {
                        completion(status == .granted)
                    }
                }
            }
        }
    }
    
    func requestAuthenticationStatus(_ completion : @escaping (_ result: VideoSubscriberAccountManagerResult?, _ error: VSError?) -> Void) {
        
        let request = VSAccountMetadataRequest()
        request.includeAccountProviderIdentifier = true
        request.includeAuthenticationExpirationDate = true
        request.isInterruptionAllowed = false
        
        self.videoSubscriberAccountManager.enqueue(request) { (userMetadata, error) in
            if let data = userMetadata {
                DispatchQueue.main.async {
                    completion(VideoSubscriberAccountManagerResult.createFromMetadata(data), error as? VSError)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, error as? VSError)
                }
            }
        }
    }
    
    func requestDeviceAuthenticationIfNotAuthenticated(_ completion : @escaping (_ result: VideoSubscriberAccountManagerResult?, _ error: VSError?) -> Void) {
        let request = VSAccountMetadataRequest()
        request.includeAccountProviderIdentifier = true
        request.includeAuthenticationExpirationDate = true
        request.isInterruptionAllowed = true
        
        self.videoSubscriberAccountManager.enqueue(request) { (userMetadata, error) in
            print("\(String(describing: userMetadata))")
            if let data = userMetadata {
                DispatchQueue.main.async {
                    completion(VideoSubscriberAccountManagerResult.createFromMetadata(data), error as? VSError)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, error as? VSError)
                }
            }
        }
    }
    
    func requestAppLevelAuthentication(_ completion : @escaping (_ result: VideoSubscriberAccountManagerResult?, _ error: VSError?) -> Void) {
        let request = VSAccountMetadataRequest()
        //request.verificationToken = token
        //request.channelIdentifier = channelIdentifier
        request.isInterruptionAllowed = true
        //request.attributeNames = requestedAttributes
        
        self.videoSubscriberAccountManager.enqueue(request) { (userMetadata, error) in
            if let data = userMetadata {
                DispatchQueue.main.async {
                    completion(VideoSubscriberAccountManagerResult.createFromMetadata(data), error as? VSError)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil, error as? VSError)
                }
            }
        }
    }
}
