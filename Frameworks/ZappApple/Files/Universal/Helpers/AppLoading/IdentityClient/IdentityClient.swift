//
//  IdentityClient.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/30/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappCore

public class IdentityClient: IdentityClientBase {
    public struct IdentityClientKeys {
        static let registerPushTokenTemplate = "%@devices/%@.json"
        static let pushTagForDeviceTemplate = "%@devices/%@/tags/%@.json"
        static let deviceAPNSToken = "device[apns_token]"
    }

    public override func createSession(completion: ((Bool, [String: Any]?, HTTPStatusCode?) -> Void)?) {
        super.createSession { _, _, responseCode in
            if responseCode == .forbidden {
                // In case session generation failed - check if its because of HTTP error 403.
                // In that case - post a notification - delete local Identifiers and close the app

                let message = "A communication error has occurred, Please restart the application"
                let okString = "OK"
                let alert = UIAlertController(title: nil,
                                              message: message,
                                              preferredStyle: .alert)

                let okButton = UIAlertAction(title: okString,
                                             style: .default,
                                             handler: { _ in
                                                 exit(0)
                })

                alert.addAction(okButton)
                let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                rootViewController?.topMostModalViewController()?.present(alert,
                                                                          animated: true,
                                                                          completion: nil)
            }
        }
    }
}
