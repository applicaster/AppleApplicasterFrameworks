//
//  FacadeConnectorConnnectivityProtocol.swift
//  ZappCore
//
//  Created by Alex Zchut on 29/03/2020.
//

import Foundation

@objc public protocol FacadeConnectorConnnectivityProtocol {
    /**
     Get online status
     */
    @objc func isOnline() -> Bool
    /**
     Get offline status
     */
    @objc func isOffline() -> Bool
    
    /**
     Get online wifi status
     */
    @objc func isOnlineViaWifi() -> Bool
}
