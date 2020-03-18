//
//  LocalNotificationResponseParser.swift
//  ZappCore
//
//  Created by Anton Kononenko on 3/18/20.
//

import Foundation

public class LocalNotificationResponseParser {
    public class func urlFromLocalNotification(response: UNNotificationResponse) -> URL? {
        let payload = response.notification.request.content.userInfo
        let actionIdentifier = response.actionIdentifier

        if let url = urlFromActionPayload(payload: payload,
                                          actionIdentifier: actionIdentifier) {
            return url
        }
        return nil
    }

    class func urlForDefaultActionsPayload(payload: [AnyHashable: Any],
                                           actionIdentifier: String) -> URL? {
        let defaultActionKey = defaultActionKeyFromActionIdentifier(actionIdentifier: actionIdentifier)

        return urlFromPayloadForDefaultKey(payload: payload,
                                           key: defaultActionKey)
    }

    class func defaultActionKeyFromActionIdentifier(actionIdentifier: String) -> String? {
        if actionIdentifier == UNNotificationDismissActionIdentifier {
            return LocalNotificationPayloadConst.dismissActionUrl
        } else if actionIdentifier == UNNotificationDefaultActionIdentifier {
            return LocalNotificationPayloadConst.defaultActionUrl
        }
        return nil
    }

    class func urlFromPayloadForDefaultKey(payload: [AnyHashable: Any],
                                           key: String?) -> URL? {
        guard let key = key else {
            return nil
        }

        if let urlString = payload[key] as? String,
            let url = URL(string: urlString) {
            return url
        }
        return nil
    }

    class func urlFromActionPayload(payload: [AnyHashable: Any],
                                    actionIdentifier: String) -> URL? {
        if let actions = payload[LocalNotificationPayloadConst.actions] as? [[AnyHashable: String]] {
            for buttonData in actions {
                if let urlString = buttonData[LocalNotificationPayloadActions.url],
                    let identifier = buttonData[LocalNotificationPayloadActions.identifier],
                    identifier == actionIdentifier,
                    let url = URL(string: urlString) {
                    return url
                }
            }
        }
        return nil
    }
}
