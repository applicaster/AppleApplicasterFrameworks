//
//  LocalNotificationManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/11/20.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import Foundation
import UserNotifications
import ZappCore

public class LocalNotificationManager: NSObject {
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert,
                                           .sound,
                                           .badge]

    func requestLocalNotification(payload: [AnyHashable: Any],
                                  fireNow: Bool = false,
                                  completion: @escaping (_ scheduled: Bool, _ error: Error?) -> Void) {
        guard let identifier = payload[LocalNotificationPayloadConst.identifier] as? String else {
            completion(false, nil) // TODO: Add error
            return
        }
        requestPermission { isGranted in
            if isGranted {
                self.addLocalNotification(identifier: identifier,
                                          payload: payload,
                                          fireNow: fireNow,
                                          completion: completion)
            }
        }
    }

    func addLocalNotification(identifier: String,
                              payload: [AnyHashable: Any],
                              fireNow: Bool = false,
                              completion: @escaping (_ scheduled: Bool, _ error: Error?) -> Void) {
        guard let trigger = UNNotificationTrigger.trigger(payload: payload,
                                                          fireNow: fireNow) else {
            completion(false, nil) // TODO: Add error
            return
        }

        let content = UNMutableNotificationContent(payload: payload)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: trigger)
        notificationCenter.add(request) { error in
            completion(error == nil, error)
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }

    func requestScheduleLocalNotifications(competion: @escaping (_ isGranted: Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission(competion: competion)
            case .authorized,
                 .provisional:
                competion(true)
            default:
                break
            }
        }
    }

    func requestPermission(competion: @escaping (_ isGranted: Bool) -> Void) {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: options) { granted, error in
                competion(granted == true && error == nil)
            }
    }

    func testLocalNotification() {
        // TODO: Decide if needed to be implemented categories with buttons
        let content = UNMutableNotificationContent()

        let userActions = "User_Actions"
        content.categoryIdentifier = userActions

        let snoozeAction = UNNotificationAction(identifier: "Snooze",
                                                title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete",
                                                title: "Delete", options: [.destructive])

        let category = UNNotificationCategory(identifier: userActions,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])

        notificationCenter.setNotificationCategories([category])
    }
}

extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    // TODO: Implement sender to ui plugin
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        let request = notification.request
        let content = request.content
        let actionIdentifier = response.actionIdentifier

        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        completionHandler()
    }
}

extension LocalNotificationManager: FacadeConnectorLocalNotificationProtocol {
    public func cancelLocalNotification(_ identifiers: [String]?) {
        guard let identifiers = identifiers else {
            return
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    public func scheduleLocalNotification(_ payload: [AnyHashable: Any],
                                          completion: @escaping (Bool, Error?) -> Void) {
        requestLocalNotification(payload: payload,
                                 completion: completion)
    }

    public func presentLocalNotification(_ payload: [AnyHashable: Any],
                                         completion: @escaping (Bool, Error?) -> Void) {
        requestLocalNotification(payload: payload,
                                 fireNow: true,
                                 completion: completion)
    }
}
