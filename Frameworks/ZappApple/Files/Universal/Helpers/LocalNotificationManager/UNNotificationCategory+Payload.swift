//
//  UNNotificationCategory+Payload.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/16/20.
//

import Foundation
import ZappCore

extension UNNotificationCategory {
    class func category(payload: [AnyHashable: Any]) -> UNNotificationCategory? {
        var categoryIdentifier = "Default-Category"
        var actionButtons: [UNNotificationAction] = []
        if let actions = payload[LocalNotificationPayloadConst.actions] as? [[AnyHashable: Any]] {
            for actionButtonsData in actions {
                if let actionIdentifier = actionButtonsData[LocalNotificationPayloadActions.identifier] as? String,
                    let title = actionButtonsData[LocalNotificationPayloadActions.title] as? String {
                    var options: UNNotificationActionOptions = []
                    if let buttonType = actionButtonsData[LocalNotificationPayloadActions.buttonType] as? String {
                        if buttonType == LocalNotificationPayloadActions.ButtonType.danger {
                            options.insert(.destructive)
                            break
                        }
                    }
                    categoryIdentifier += "-\(actionIdentifier)"
                     actionButtons.append(UNNotificationAction(identifier: actionIdentifier,
                                                                                     title: title,
                                                                                     options: options))
                }
            }
        }
        return UNNotificationCategory(identifier: categoryIdentifier,
                                      actions: actionButtons,
                                      intentIdentifiers: [],
                                      options: [.customDismissAction])
    }
}
