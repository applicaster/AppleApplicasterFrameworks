//
//  CrashlogsMsAppCenter.swift
//  CrashlogsMsAppCenter
//
//  Created by Alex Zchut on 24/09/2019.
//  Copyright © 2019 Applicaster Ltd. All rights reserved.
//

import AppCenter
import AppCenterCrashes
import UIKit
import ZappCore

public class CrashlogsMsAppCenter: NSObject, CrashlogsPluginProtocol {
    public func prepareProvider(completion: (_ isReady: Bool) -> Void) {
        MSAppCenter.startService(MSCrashes.self)
        completion(true)
    }

    public required override init() {
        super.init()
    }

    public var configurationJSON: NSDictionary?

    public required init(configurationJSON: NSDictionary?) {
        super.init()
        self.configurationJSON = configurationJSON
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
