//
//  FacadeConnectorLocalNotificationProtocol.swift
//  ZappCore
//
//  Created by Anton Kononenko on 3/13/20.
//

import Foundation

@objc public protocol FacadeConnectorLocalNotificationProtocol {
    func cancelLocalNotification(_ identifiers: [String]?,
                                 completion: @escaping (_ scheduled: Bool, _ error: Error?) -> Void)
    func presentLocalNotification(_ payload: [AnyHashable: Any],
                                  completion: @escaping (_ scheduled: Bool, _ error: Error?) -> Void)
}
