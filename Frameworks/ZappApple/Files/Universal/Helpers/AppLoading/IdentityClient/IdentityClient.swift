//
//  IdentityClient.swift
//  ZappApple
//
//  Created by Anton Kononenko on 1/30/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import ZappCore

public class IdentityClient: IdentityClientBase {
    public struct IdentityClientKeys {
        static let registerPushTokenTemplate = "%@devices/%@.json"
        static let pushTagForDeviceTemplate = "%@devices/%@/tags/%@.json"
        static let deviceAPNSToken = "device[apns_token]"
    }

    public override func createSession(completion: ((Bool, [String: Any]?, HTTPStatusCode?) -> Void)?) {
        super.createSession { _, _, responseCode in
            if responseCode == .forbidden {
                // In case session generation failed - check if its because of HTTP error 403.
                // In that case - post a notification - delete local Identifiers and close the app

                let message = "A communication error has occurred, Please restart the application"
                let okString = "OK"
                let alert = UIAlertController(title: nil,
                                              message: message,
                                              preferredStyle: .alert)

                let okButton = UIAlertAction(title: okString,
                                             style: .default,
                                             handler: { _ in
                                                 exit(0)
                })

                alert.addAction(okButton)
                let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                rootViewController?.topMostModalViewController()?.present(alert,
                                                                          animated: true,
                                                                          completion: nil)
            }
        }
    }

    /// Register for push notifications agains the AIS server
    ///
    /// - Parameter token: Token data for Push Notification
    @objc public func registerForPushNotification(with token: Data) {
        guard let url = createRegisterPushTokenURL(with: token),
            let request = createURLRequest(from: url,
                                           method: IdentityClientBaseKeys.PutMethod) else {
            return
        }

        let task = URLSession.shared.dataTask(with: request) { _, response, _ in
            if let response = response as? HTTPURLResponse {
                if response.status == .ok {
                    debugPrint("Successfully Registered Push to AIS - Token = \(token)")
                } else {
                    debugPrint("Failed to Register Push to AIS - Token = \(token)")
                }
            }
        }
        task.resume()
    }

    /// Create URL for register push reuqest
    ///
    /// - Parameter token: Token data for Push Notification
    /// - Returns: URL if can be created, otherwise nil
    private func createRegisterPushTokenURL(with token: Data) -> URL? {
        guard let deviceID = LocalStorage.sharedInstance.get(key: ZappStorageKeys.uuid,
                                                             namespace: nil) else {
            return nil
        }

        let urlPath = String(format: IdentityClientKeys.registerPushTokenTemplate,
                             deviceID,
                             bucketID)
        var urlComponent = URLComponents(string: urlPath)
        urlComponent?.queryItems = registerPushTokeURLQueryItems(token: token)

        return urlComponent?.url
    }

    /// Retirieve query items for push notification request
    ///
    /// - Parameter token: Token data for Push Notification
    /// - Returns: Array of the query items
    private func registerPushTokeURLQueryItems(token: Data) -> [URLQueryItem] {
        var retVal: [URLQueryItem] = []
        retVal.append(URLQueryItem(name: IdentityClientKeys.deviceAPNSToken,
                                   value: token.description))
        return retVal
    }

    /// Add Push tag to device
    ///
    /// - Parameter tag: Push Notification tag to add
    @objc public func addTagToDevice(tag: String) {
        sendRequest(for: tag,
                    method: IdentityClientBaseKeys.PutMethod)
    }

    /// Remove Push tag from device
    ///
    /// - Parameter tag: Push Notification tag to remove
    @objc public func removeTagFromDevice(tag: String) {
        sendRequest(for: tag,
                    method: IdentityClientBaseKeys.DeleteMethod)
    }

    /// Sent request for tag
    ///
    /// - Parameters:
    ///   - tag: Push Notification tag
    ///   - method: REST method of the request
    private func sendRequest(for tag: String,
                             method: String) {
        guard let url = createPushTagForDeviceURL(tag: tag),
            let request = createURLRequest(from: url,
                                           method: method) else {
            return
        }

        let task = URLSession.shared.dataTask(with: request) { _, response, _ in
            if let response = response as? HTTPURLResponse {
                if response.status == .ok {
                    debugPrint("Successfully Registered to group - \(tag)")
                } else {
                    debugPrint("Failed to Register Push to group - \(tag)")
                }
            }
        }
        task.resume()
    }

    /// Create url for adding/removing url request
    ///
    /// - Parameter tag: Push Notification tag
    /// - Returns: URL if can be created, otherwise nil
    private func createPushTagForDeviceURL(tag: String) -> URL? {
        guard let deviceID = LocalStorage.sharedInstance.get(key: ZappStorageKeys.uuid,
                                                             namespace: nil) else {
            return nil
        }

        let urlPath = String(format: IdentityClientKeys.pushTagForDeviceTemplate,
                             deviceID,
                             bucketID,
                             tag)
        let urlComponent = URLComponents(string: urlPath)
        return urlComponent?.url
    }
}
