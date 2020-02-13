//
//  FirebaseBaseSettings.swift
//  FirebaseBaseSettings
//
//  Created by Anton Kononenko on 2/12/2020.
//  Copyright © 2020 Applicaster LTD. All rights reserved.
//

import FirebaseCore
import Foundation
import ZappCore

let kGoogleServiceFileName = "GoogleService-Info"
let kGoogleServicePlistExtension = "plist"

public class FirebaseBaseSettings: NSObject, GeneralProviderProtocol {
    public required init(pluginModel: ZPPluginModel) {
        model = pluginModel
    }

    public var model: ZPPluginModel?

    public var providerName: String {
        return "FirebaseBaseSettings"
    }

    public func prepareProvider(_ defaultParams: [String: Any],
                                completion: ((Bool) -> Void)?) {
        completion?(true)
    }

    public func disable(completion: ((Bool) -> Void)?) {
        FirebaseApp.app()?.delete({ success in
            completion?(success)
        })
    }
    
    /// Check if firebase plist exists
    var hasValidConfiguration: Bool = {
        guard let path = Bundle.main.path(forResource: kGoogleServiceFileName,
                                          ofType: kGoogleServicePlistExtension),
            let content = NSDictionary(contentsOfFile: path),
            content.count > 0 else {
            return false
        }
        return true
    }()
}
