//
//  MsAppCenterDistributionHandler.swift
//  ZappApple
//
//  Created by Anton Kononenko on 10/4/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import AppCenter
import AppCenterDistribute
import Foundation


public class MsAppCenterDistributionHandler: NSObject {
    public func configure() {
        guard let appSecret = FeaturesCustomization.MSAppCenterAppSecret() else {
            return
        }

        MSAppCenter.start(appSecret, withServices: [MSDistribute.self])
        // disable until app fully loaded
        MSDistribute.setEnabled(false)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkUpdatesForNewVersions),
            name: NSNotification.Name(kMSAppCenterCheckForUpdatesNotification),
            object: nil)
    }

    @objc func checkUpdatesForNewVersions(notification: Notification) {
        MSDistribute.setEnabled(true)
    }
}
