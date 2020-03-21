//
//  ZPAppleVideoSubscriberSSO+PlayerPreHook.swift
//  ZappAppleVideoSubscriberSSO
//
//  Created by Alex Zchut on 20/03/2020.
//

import ZappCore

extension ZPAppleVideoSubscriberSSO: PlayerDependantPluginPrehookProtocol {
    func perform(on presentationViewController: UIViewController?, completion: @escaping (_ success: Bool) -> Void) {
        self.vsaAccessOperationCompletion = completion
        self.presentationViewController = presentationViewController
        
        self.askForAccessIfNeeded(prompt: false) { (status) in
            if self.managerInfo.isAuthorized {
                self.requestAuthenticationStatus { (authResult, error) in
                    if let authResult = authResult {
                        if let id = authResult.accountProviderID {
                            if id.isEmpty {
                                self.showVSALogin()
                            } else {
                                self.processResult()
                            }
                        } else {
                            self.showVSALogin()
                        }
                    } else {
                        self.showVSALogin()
                    }
                }
            } else {
                self.processResult()
            }
        }
    }
        
    fileprivate func showVSALogin() {
        self.requestDeviceAuthenticationIfNotAuthenticated { (deviceAuthResult, error) in
            if let deviceAuthResult = deviceAuthResult {
                if let id = deviceAuthResult.accountProviderID {
                    self.managerInfo.isAuthenticated = !id.isEmpty
                }
                self.processResult()
            } else {
                self.processResult()
            }
        }
    }
    
    fileprivate func processResult() {
        let success = self.managerInfo.isAuthorized && self.managerInfo.isAuthenticated

        DispatchQueue.main.async {
            self.vsaAccessOperationCompletion?(success)
        }
    }
}
