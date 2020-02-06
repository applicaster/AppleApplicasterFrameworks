//
//  UUIDManager.swift
//  ZappApple
//
//  Created by Anton Kononenko on 2/4/20.
//

import Foundation

let UUIDKey = "APUUID"

class UUIDManager {
    /// The unique identifier for this user.
    /// The unique identifier if one has been generated. <code>nil</code> otherwise.
    public static var deviceID: String {
        return Keychain.getStringForKey(UUIDKey) ?? registerNewUUID()
    }

    class func registerNewUUID() -> String {
        let retVal = UUID().uuidString

        Keychain.setString(retVal,
                           forKey: UUIDKey)
        return retVal
    }
}
