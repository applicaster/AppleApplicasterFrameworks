//
//  CrashlogsPluginProtocol.swift
//  ZappCore
//
//  Created by Alex Zchut on 25/09/2019.
//  Copyright © 2019 Applicaster Ltd. All rights reserved.
//

import Foundation

@objc public protocol CrashlogsPluginProtocol: ZPAdapterProtocol {
    /**
     Prepare  plugin for usage

     - parameter completion: - Completion handler if plugin ready for  usage
     */
    
    @objc func prepareProvider(completion: (_ isReady: Bool) -> Void)
}
