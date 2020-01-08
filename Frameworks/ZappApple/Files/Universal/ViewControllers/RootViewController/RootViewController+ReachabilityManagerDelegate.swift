//
//  RootViewController+ReachabilityManagerDelegate.swift
//  ZappApple
//
//  Created by Anton Kononenko on 6/10/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation
import Reachability

extension RootViewController: ReachabilityManagerDelegate {
    
    func reachabilityChanged(connection: Reachability.Connection) {
        switch connection {
        case .wifi, .cellular:
            if let currentConnection = currentConnection,
                currentConnection == .none {
                forceReloadApplication()
            }
        case .none:
            showInternetError()
        }
        currentConnection = connection

    }
    
    func showInternetError() {
        userInterfaceLayerContainerView.isHidden = true
        splashScreenContainerView.isHidden = false
        
        //TODO: After will be added multi language support should be take from localization string
        splashViewController?.showErrorMessage("You are not connected to a network. Please use your device settings to connect to a network and try again.")
    }
    
    func forceReloadApplication() {
        userInterfaceLayerContainerView.isHidden = true
        splashScreenContainerView.isHidden = false
        self.userInterfaceLayerContainerView.subviews.forEach{$0.removeFromSuperview()}
        reloadApplication()
    }

}
