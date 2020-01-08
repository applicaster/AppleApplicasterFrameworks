//
//  AppDelegateProtocol.swift
//  ZappTvOS
//
//  Created by Anton Kononenko on 1/8/20.
//  Copyright © 2020 Anton Kononenko. All rights reserved.
//

import Foundation

public protocol AppDelegateProtocol {
    func handleDelayedUrlSchemeCallIfNeeded()
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]? { get }
}
