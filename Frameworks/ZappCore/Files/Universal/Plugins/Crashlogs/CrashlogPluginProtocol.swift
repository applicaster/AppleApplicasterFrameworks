//
//  CrashlogsPluginProtocol.swift
//  ZappCore
//
//  Created by Alex Zchut on 25/09/2019.
//  Copyright © 2019 Applicaster Ltd. All rights reserved.
//

import Foundation

@objc public protocol CrashlogsPluginProtocol: ZPAdapterProtocol {
    /// Prepare  plugin for usage
    /// - Parameter completion: notifies caller  that plugin has beed finished preparation
    /// - Parameter isReady: in case plugin ready to use  returns true otherwise false
    @objc func prepareProvider(completion: (_ isReady: Bool) -> Void)
}
