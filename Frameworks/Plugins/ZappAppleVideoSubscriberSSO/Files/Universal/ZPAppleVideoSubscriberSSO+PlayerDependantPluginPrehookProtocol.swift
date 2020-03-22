//
//  ZPAppleVideoSubscriberSSO+PlayerPreHook.swift
//  ZappAppleVideoSubscriberSSO
//
//  Created by Alex Zchut on 20/03/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import ZappCore

extension ZPAppleVideoSubscriberSSO: PlayerDependantPluginPrehookProtocol {
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
            
            self.getVerificationToken { (status, token, message) in
                if status, let token = token {
                    /*
                    Once the customer is authenticated to a TV provider, the next step is to request information from your service provider for the specific app using the customer’s TV provider. This information includes the verificationToken used to authenticate at the app-level and attributesNames in the metadata request. Along with this request, you are required to request at least one attribute.
                    */
                    self.requestAppLevelAuthentication(verificationToken: token) { (authResult, error) in
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

extension ZPAppleVideoSubscriberSSO: PlayerObserverProtocol {
    func playerDidFinishPlayItem(player: PlayerProtocol,
                                 completion: @escaping (_ finished: Bool) -> Void) {
        
    }

    func playerDidCreate(player: PlayerProtocol) {
        
    }

    func playerDidDismiss(player: PlayerProtocol) {
        self.performPrehook( { (success) in
            print("SSO result: \(success)")
        })
    }

    func playerProgressUpdate(player: PlayerProtocol,
                              currentTime: TimeInterval,
                              duration: TimeInterval) {
        
    }
}
