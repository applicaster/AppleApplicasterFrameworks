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
    let errorDomainNoIdentifier = "LOCAL_NOTIFICATION_MANAGER_NO_IDENTIFIER"
    let errorDomainNoTrigger = "LOCAL_NOTIFICATION_MANAGER_UNABLE_CREATE_TRIGGER"

    var foo = false //TODO: Delete
    
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert,
                                           .sound,
                                           .badge]

    func requestLocalNotification(payload: [AnyHashable: Any],
                                  completion: @escaping (_ scheduled: Bool, _ error: Error?) -> Void) {
        let error = NSError(domain: errorDomainNoIdentifier,
                            code: 0,
                            userInfo: (payload as? [String: Any]) ?? [:])
        guard let identifier = payload[LocalNotificationPayloadConst.identifier] as? String else {
            completion(false, error)
            return
        }
        requestScheduleLocalNotifications { isGranted in
            DispatchQueue.main.async {
                if isGranted {
                    self.notificationCenter.getNotificationCategories { categories in
                        self.addLocalNotification(identifier: identifier,
                                                  payload: payload,
                                                  currentCategories: categories,
                                                  completion: completion)
                    }
                }
            }
        }
    }

    func addLocalNotification(identifier: String,
                              payload: [AnyHashable: Any],
                              currentCategories: Set<UNNotificationCategory>,
                              completion: @escaping (_ scheduled: Bool, _ error: Error?) -> Void) {
        let error = NSError(domain: errorDomainNoTrigger,
                            code: 0,
                            userInfo: (payload as? [String: Any]) ?? [:])
        guard let trigger = UNNotificationTrigger.trigger(payload: payload) else {
            completion(false, error)
            return
        }

        let content = UNMutableNotificationContent(payload: payload)

        if let category = UNNotificationCategory.category(payload: payload) {
            var newCategories = currentCategories
            newCategories.insert(category)

            notificationCenter.setNotificationCategories(newCategories)
            content.categoryIdentifier = category.identifier
        }

        content.attachments = UNNotificationAttachment.attachments(payload: payload)

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
        notificationCenter.requestAuthorization(options: options) { granted, error in
            competion(granted == true && error == nil)
        }
    }
}
