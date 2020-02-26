//
//  UrlSchemeHandler.swift
//  ZappApple
//
//  Created by Alex Zchut on 26/02/2020.
//

import Foundation

public class UrlSchemeHandler {
    
    enum SystemActions: String {
        case generateNewUUID
    }
    
    public class func handle(_ application: UIApplication,
                           open url: URL,
                           options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        var retValue = false
        let systemAction = SystemActions(rawValue: url.host ?? "")
        
        switch systemAction {
        case .generateNewUUID:
            retValue = self.handleUUIDregeneration()
        default:
            break
        }
        
       return retValue
    }
}
