//
//  UNMutableNotificationContent+Payload.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/11/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import UserNotifications

extension UNMutableNotificationContent {
    convenience init(payload: [AnyHashable: Any]) { self.init()
        title = payload[LocalNotificationPayloadConst.title] as? String ?? ""
        subtitle = payload[LocalNotificationPayloadConst.subtitle] as? String ?? ""
        body = payload[LocalNotificationPayloadConst.body] as? String ?? ""
        badge = payload[LocalNotificationPayloadConst.badge] as? NSNumber
        userInfo = payload[LocalNotificationPayloadConst.userInfo] as? [AnyHashable: Any] ?? [:]
        if let soundName = payload[LocalNotificationPayloadConst.sound] as? String {
            let notificationSoundName = UNNotificationSoundName(rawValue: soundName)
            sound = UNNotificationSound(named: notificationSoundName)
        } else {
            sound = UNNotificationSound.default
        }
    }
}
