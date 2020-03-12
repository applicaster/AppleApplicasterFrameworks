//
//  LocalNotificationPayloadConst.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/12/20.
//

import Foundation

struct LocalNotificationPayloadConst {
    /// Title of the local notification
    static let title = "title"

    /// Subtitle of the local notification
    static let subtitle = "subtitle"

    /// Body of the local notification
    static let body = "body"

    /// Defines number of the badge that willl be shown in circle near the app logo, can be empty
    static let badge = "badge"

    /// User Info that stores additionall information passed with local notification
    static let userInfo = "userInfo"

    /// Sound name that willl be used when local notification fired, in case empty will be used default
    static let sound = "sound"

    /// Defines if local notification must schedule repetative
    static let repeats = "repeats"

    /// Defines offset in seconds before local notification will be fired
    static let offset = "offset"

    /// Defines unix timestamp date when local notification will be fired
    static let unixTimestamp = "unixTimestamp"
}
