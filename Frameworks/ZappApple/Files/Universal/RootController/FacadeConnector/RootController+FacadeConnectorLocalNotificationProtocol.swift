//
//  RootController+FacadeConnectorLocalNotificationProtocol.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/13/20.
//

import Foundation
import ZappCore

extension RootController: FacadeConnectorLocalNotificationProtocol {
    public func cancelLocalNotification(_ identifiers: [String]?) {
        localNotificationManager.cancelLocalNotification(identifiers)
    }

    public func presentLocalNotification(_ payload: [AnyHashable: Any],
                                         completion: @escaping (Bool, Error?) -> Void) {
        localNotificationManager.presentLocalNotification(payload,
                                                          completion: completion)
    }
}
