//
//  ZPAppleVideoSubscriberSSO+VSAccountManagerInteraction.swift
//  ZappAppleVideoSubscriberSSO
//
//  Created by Alex Zchut on 20/03/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

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
    
    func verify(for providerId: String) -> Bool {
        guard let accountProviderID = accountProviderID, providerId == accountProviderID,
            let authExpirationDate = authExpirationDate, authExpirationDate > Date(),
            let _ = verificationData else {
                return false
        }
        return true
    }
}

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
        request.isInterruptionAllowed = true
        
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
