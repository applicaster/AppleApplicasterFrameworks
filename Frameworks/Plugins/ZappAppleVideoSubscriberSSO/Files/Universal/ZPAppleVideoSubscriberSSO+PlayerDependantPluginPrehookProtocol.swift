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
            if self.managerInfo.isAuthorized {
                self.requestAuthenticationStatus { (authResult, error) in
                    if let authResult = authResult {
                        self.managerInfo.isAuthenticated = authResult.verify(for: self.providerIdentifier)
                        if self.managerInfo.isAuthenticated {
                            self.processResult()
                        } else {
                            self.vsaLogin()
                        }
                    } else {
                        self.vsaLogin()
                    }
                }
            } else {
                self.processResult()
            }
        }
    }
        
    fileprivate func vsaLogin() {
        self.requestDeviceAuthenticationIfNotAuthenticated { (deviceAuthResult, error) in
            if let deviceAuthResult = deviceAuthResult {
                self.managerInfo.isAuthenticated = deviceAuthResult.verify(for: self.providerIdentifier)
            }
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
