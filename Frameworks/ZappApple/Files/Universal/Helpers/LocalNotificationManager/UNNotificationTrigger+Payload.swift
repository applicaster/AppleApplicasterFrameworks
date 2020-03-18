//
//  UNNotificationTrigger+Payload.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/12/20.
//

import Foundation
import ZappCore

extension UNNotificationTrigger {
    class func trigger(payload: [AnyHashable: Any]) -> UNNotificationTrigger? {
        if let unixTimestamp = retrieveUnixTimeStamp(payload: payload) {
            let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
            let timeInterval = date.timeIntervalSinceNow
            return timeInterval > 0 ? UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                                        repeats: false) : nil
        } else {
            return UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                     repeats: false)
        }
    }

    class func retrieveUnixTimeStamp(payload: [AnyHashable: Any]) -> Double? {
        if let retVal = payload[LocalNotificationPayloadConst.unixTimestamp] as? NSNumber {
            return retVal.doubleValue
        } else if let timestampString = payload[LocalNotificationPayloadConst.unixTimestamp] as? String,
            let retVal = Double(timestampString) {
            return retVal
        }
        return nil
    }
}
