//
//  UNNotificationTrigger+Payload.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/12/20.
//

import Foundation

extension UNNotificationTrigger {
    class func trigger(payload: [AnyHashable: Any]) -> UNNotificationTrigger? {
        let repeats = payload[LocalNotificationPayloadConst.repeats] as? Bool ?? false
        if let offset = payload[LocalNotificationPayloadConst.offset] as? Int {
            return UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(offset),
                                                     repeats: repeats)
        } else if let unixTimestamp = payload[LocalNotificationPayloadConst.unixTimestamp] as? Int {
            let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
            let timeInterval = date.timeIntervalSinceNow
            return timeInterval > 0 ? UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                                        repeats: repeats) : nil
        }
        return nil
    }
}
