//
//  UNNotificationTrigger+Payload.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/12/20.
//

import Foundation
import ZappCore

extension UNNotificationTrigger {
    class func trigger(payload: [AnyHashable: Any],
                       fireNow: Bool) -> UNNotificationTrigger? {
        let repeats = payload[LocalNotificationPayloadConst.repeats] as? Bool ?? false
        if fireNow {
            return UNTimeIntervalNotificationTrigger(timeInterval: 0,
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
