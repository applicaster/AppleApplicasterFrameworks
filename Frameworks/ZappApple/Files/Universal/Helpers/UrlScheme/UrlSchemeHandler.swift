//
//  UrlSchemeHandler.swift
//  ZappApple
//
//  Created by Alex Zchut on 26/02/2020.
//

import Foundation

class UrlSchemeHandler {
    
    enum SystemActions: String {
        case generateNewUUID
    }

    class func handle(_ application: UIApplication,
                           open url: URL,
                           options: [UIApplication.OpenURLOptionsKey: Any] = [:],
                           completion: @escaping (_ success: Bool) -> Void) {
        
        let systemAction = SystemActions(rawValue: url.host ?? "")
        
        switch systemAction {
        case .generateNewUUID:
            self.handleUUIDregeneration()
            
        default:
            break
        }
    }
}
