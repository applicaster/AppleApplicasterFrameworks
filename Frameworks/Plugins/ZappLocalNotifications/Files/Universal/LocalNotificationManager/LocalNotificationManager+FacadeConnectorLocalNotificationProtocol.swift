//
//  LocalNotificationManager+FacadeConnectorLocalNotificationProtocol.swift
//  QuickBrickApple
//
//  Created by Anton Kononenko on 3/18/20.
//

import Foundation
import ZappCore

extension LocalNotificationManager: FacadeConnectorLocalNotificationProtocol {
    public func cancelLocalNotification(_ identifiers: [String]?,
                                        completion: @escaping (Bool, Error?) -> Void) {
        guard let identifiers = identifiers else {
            return
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        completion(true, nil)
    }

    public func presentLocalNotification(_ payload: [AnyHashable: Any],
                                         completion: @escaping (Bool, Error?) -> Void) {
        if foo == false {
            requestLocalNotification(payload: payload,
                                     completion: completion)
        }
        foo = true
    }
}
