//
//  ZPAppleVideoSubscriberSSO+VSAccountManagerDelegate.swift
//  ZappAppleVideoSubscriberSSO
//
//  Created by Alex Zchut on 20/03/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import VideoSubscriberAccount

extension ZPAppleVideoSubscriberSSO: VSAccountManagerDelegate {
    func accountManager(_ accountManager: VSAccountManager, present viewController: UIViewController) {
        DispatchQueue.main.async {
            self.presentationViewController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    func accountManager(_ accountManager: VSAccountManager, dismiss viewController: UIViewController) {
        DispatchQueue.main.async {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func accountManager(_ accountManager: VSAccountManager, shouldAuthenticateAccountProviderWithIdentifier accountProviderIdentifier: String) -> Bool {
        return !managerInfo.isAuthenticated
    }

}
