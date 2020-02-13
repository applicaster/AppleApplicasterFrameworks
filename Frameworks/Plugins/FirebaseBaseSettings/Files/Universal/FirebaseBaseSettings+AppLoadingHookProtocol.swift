//
//  FirebaseBaseSettings+AppLoadingHookProtocol.swift
//  FirebaseBaseSettings
//
//  Created by Anton Kononenko on 2/12/20.
//

import FirebaseCore
import Foundation
import ZappCore

extension FirebaseBaseSettings: AppLoadingHookProtocol {
    @objc public func executeOnLaunch(completion: (() -> Void)?) {
        guard FirebaseApp.app() == nil,
            hasValidConfiguration else {
            completion?()
            return
        }
        FirebaseApp.configure()
        completion?()
    }
}
