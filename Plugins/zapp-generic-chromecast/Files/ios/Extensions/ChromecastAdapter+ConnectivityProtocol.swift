//
//  ChromecastAdapter+ReachabilityManagerDelegate.swift
//  ZappGeneralPluginChromecast
//
//  Created by Alex Zchut on 29/03/2020.
//  Copyright © 2020 Applicaster. All rights reserved.
//

import ZappCore

protocol ConnectivityProtocol {
    func isCastSessionConnected() -> Bool
    func isReachableViaWiFi() -> Bool
    func addConnectivityListener()
    func removeConnectivityListener()
    func updateCastButtonVisibility()
}

extension ChromecastAdapter: ConnectivityProtocol {
    
    // MARK: - Cast session connection
    func isCastSessionConnected() -> Bool {
        return isReachableViaWiFi() && self.hasConnectedCastSession() == true
    }

    func isReachableViaWiFi() -> Bool {
        self.connectivityState = FacadeConnector.connector?.connectivity?.getCurrentConnectivityState() ?? self.connectivityState
        return connectivityState == .wifi
    }
    
    func addConnectivityListener() {
        FacadeConnector.connector?.connectivity?.addConnectivityListener(self)
    }
    
    func removeConnectivityListener() {
        FacadeConnector.connector?.connectivity?.removeConnectivityListener(self)
    }
    
    func updateCastButtonVisibility() {
        switch self.connectivityState {
        case .offline:
            //hide cc button if no network and the button is presented
            if let button = self.castButton,
                button.isHidden == false {
                button.isHidden = true
            }
            break
        default:
            //show cc button if hidden and devices are available and network is ok
            //hide cc button if no devices are available after network change
            if let button = self.castButton,
                button.isHidden == self.hasAvailableChromecastDevices() {
                button.isHidden = !self.hasAvailableChromecastDevices()
            }
            break
        }
    }
}

extension ChromecastAdapter: ConnectivityListener {
    public func connectivityStateChanged(_ state: ConnectivityState) {
        self.connectivityState = state
    }
}
