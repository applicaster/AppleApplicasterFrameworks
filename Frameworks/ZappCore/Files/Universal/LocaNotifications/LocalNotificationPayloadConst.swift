//
//  LocalNotificationPayloadConst.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/12/20.
//

import Foundation

public struct LocalNotificationPayloadConst {
    /// Uniquie identifier of the local notification
    public static let identifier = "identifier"

    /// Title of the local notification
    public static let title = "title"

    /// Subtitle of the local notification
    public static let subtitle = "subtitle"

    /// Body of the local notification
    public static let body = "body"

    /// Defines number of the badge that willl be shown in circle near the app logo, can be empty
    public static let badge = "badge"

    /// User Info that stores additionall information passed with local notification
    public static let userInfo = "userInfo"

    /// Sound name that willl be used when local notification fired, in case empty will be used default
    public static let sound = "sound"

    /// Defines if local notification must schedule repetative
    public static let repeats = "repeats"

    /// Defines unix timestamp date when local notification will be fired
    public static let unixTimestamp = "unixTimestamp"

    /// Date in readable format yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ
    public static let date = "date"

    /// Date format
    public static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    
    /// Category identifier
    public static let category = "category"
    
    /// response of the local notification
    public static let response = "response"
    
    /// Dictionary of the buttons provided for local notification, use `dismiss` to select distuctive red button
    public static let actions = "actions"
}

public struct LocalNotificationResponse {
    public static let defaultButton = "default"
    public static let dismissButton = "dismiss"
}
