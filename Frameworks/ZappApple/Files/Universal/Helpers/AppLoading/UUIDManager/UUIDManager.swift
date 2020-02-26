//
//  UUIDManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 2/4/20.
//

import Foundation
import ZappCore

let UUIDKey = "APUUID"

public class UUIDManager {
    /// The unique identifier for this user.
    /// The unique identifier if one has been generated. <code>nil</code> otherwise.
    public static var deviceID: String {
        var retValue = ""
                
        guard let bundleIdentifier = FacadeConnector.connector?.storage?.sessionStorageValue(for: ZappStorageKeys.bundleIdentifier, namespace: nil),
        let deviceType = FacadeConnector.connector?.storage?.sessionStorageValue(for: ZappStorageKeys.deviceType, namespace: nil) else {
            return fetchOrCreateNewKey()
        }
        
        let uuidType1 = "\(bundleIdentifier) - APUUID"
        let uuidType2 = "\(bundleIdentifier)-\(deviceType)-APUUID"
        
        if let value = Keychain.getStringForKey(uuidType1) {
            retValue = value
        } else if let value = Keychain.getStringForKey(uuidType2) {
            retValue = value
        }
        
        if retValue.isEmpty {
            retValue = fetchOrCreateNewKey()
        }
        return retValue
    }
    
    static func fetchOrCreateNewKey() -> String {
        return Keychain.getStringForKey(UUIDKey) ?? registerNewUUID()
    }
    
    public class func regenerateUUID() {
        _ = self.registerNewUUID()
    }
    
    /// Creates new UUID key and save it to Keychain
    class func registerNewUUID() -> String {
        let retVal = UUID().uuidString

        Keychain.setString(retVal,
                           forKey: UUIDKey)
        return retVal
    }
}
