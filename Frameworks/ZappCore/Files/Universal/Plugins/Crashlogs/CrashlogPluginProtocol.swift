//
//  CrashlogsPluginProtocol.swift
//  ZappCore
//
//  Created by Alex Zchut on 25/09/2019.
//  Copyright © 2019 Applicaster Ltd. All rights reserved.
//

import Foundation

/// Conforming this protocol allows Zapp Crash logger plugin to support generic analytics system of Zapp App
@objc public protocol CrashlogsPluginProtocol: ZPAdapterProtocol {
    /// Prepare  plugin for usage
    /// - Parameter completion: notifies caller  that plugin has beed finished preparation
    /// - Parameter isReady: in case plugin ready to use  returns true otherwise false
    @objc func prepareProvider(completion: (_ isReady: Bool) -> Void)
}
