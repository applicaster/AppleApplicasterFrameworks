//
//  ZappCrashlogsMsAppCenter.swift
//  ZappCrashlogsMsAppCenter
//
//  Created by Alex Zchut on 24/09/2019.
//  Copyright © 2019 Applicaster Ltd. All rights reserved.
//

import AppCenter
import AppCenterCrashes
import UIKit
import ZappCore

public class ZappCrashlogsMsAppCenter: NSObject, CrashlogsPluginProtocol {
    public required init(pluginModel: ZPPluginModel) {
        model = pluginModel
    }

    public var model: ZPPluginModel?

    public var providerName: String {
        "Crashlog MS App Center"
    }

    public func prepareProvider(_ defaultParams: [String: Any], completion: (Bool) -> Void) {
        MSAppCenter.startService(MSCrashes.self)
        completion(true)
    }

    public func disable(completion: ((Bool) -> Void)?) {
        MSAppCenter.setEnabled(false)
        completion?(true)
    }
}
