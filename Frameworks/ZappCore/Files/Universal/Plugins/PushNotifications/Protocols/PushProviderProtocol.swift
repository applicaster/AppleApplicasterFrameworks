//
//  PushProviderProtocol.swift
//  ZappCore
//
//  Created by Anton Kononenko on 1/23/20.
//  Copyright © 2020 Applicaster LTD. All rights reserved.
//


import Foundation

@objc public protocol PushProviderProtocol: ZPAdapterProtocol {

    /// Readable name of the analytics plugin
    var providerName: String { get }
    
    /// Invokation of this function must prepare push notification plugin for use.
    /// - Attention: Application will wait completion of this func to present application.
    /// Completion must be called as soon as  possible
    /// - Parameters:
    ///   - defaultParams: default parameters for push plugins
    ///   - completion: Completion handler that notify app level that component  ready to  be presented or fail
    ///   - isReady: notify callback if analytics plugin is ready for use
    func prepareProvider(_ defaultParams: [String: Any],
                         completion: (_ isReady: Bool) -> Void)
    
    /**
     add tags to device
     */
    @objc optional func addTagsToDevice(_ tags: [String]?,
                                        completion: @escaping (_ success: Bool ,_ tags: [String]?) -> Void)
    
    /**
     remove tags from device
     */
    @objc optional func removeTagsToDevice(_ tags: [String]?,
                                           completion: @escaping (_ success: Bool, _ tags: [String]?) -> Void)
    
    /**
     get device's tag list
     */
    @objc optional func getDeviceTags() -> [String]?
    
    /**
     register Token with push server.
     */
    @objc optional func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data)
    
    /**
     register userNotificationSettings with push server
     */
    @objc optional func didRegisterUserNotificationSettings(_ notificationSettings: UNNotificationSettings)

}
