//
//  RootController+FacadeConnectorConnectivityProtocol.swift
//  ZappApple
//
//  Created by Alex Zchut on 29/03/2020.
//

import Foundation
import ZappCore
import Reachability

extension RootController: FacadeConnectorConnnectivityProtocol {
    public func isOnline() -> Bool {
        var revValue = false
        
        switch self.currentConnection {
        case .wifi, .cellular:
            revValue = true
        default:
            break
        }
        
        return revValue
    }
    
    public func isOffline() -> Bool {
        return !isOnline()
    }
    
    public func isOnlineViaWifi() -> Bool {
        var revValue = false
        
        switch self.currentConnection {
        case .wifi:
            revValue = true
        default:
            break
        }
        
        return revValue
    }
}
