//
//  ChromecastAdapter+AppLoadingHookProtocol.swift
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 29/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import ZappCore

extension ChromecastAdapter: AppLoadingHookProtocol {
    public func executeAfterAppRootPresentation(displayViewController: UIViewController?, completion: (() -> Void)?) {
        presentIntroductionScreenIfNeeded()
    }
}
