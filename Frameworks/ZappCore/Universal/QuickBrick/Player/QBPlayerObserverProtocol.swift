//
//  QBPlayerObserverProtocol.swift
//  ZappPlugins
//
//  Created by Anton Kononenko on 7/26/19.
//  Copyright © 2019 Applicaster LTD. All rights reserved.
//

import Foundation

@objc public protocol QBPlayerObserverProtocol {
    
    /// Player finished play video item
    ///
    /// - Parameters:
    ///   - player: instance of the player that conform QBPlayerProtocol protocol
    ///   - completion: completion when all dependant item will be completed player can start next move or can be closed
    func playerDidFinishPlayItem(player:QBPlayerProtocol,
                                 completion:@escaping (_ finished:Bool) -> Void)
    
    /// Player instance did created
    ///
    ///  - player: instance of the player that conform QBPlayerProtocol protocol
    func playerDidCreate(player:QBPlayerProtocol)
    
    /// Player instance did dismiss
    ///
    ///  - player: instance of the player that conform QBPlayerProtocol protocol
    func playerDidDismiss(player:QBPlayerProtocol)
    
    /// Player instance update current time
    ///
    /// - Parameters:
    ///  - player: instance of the player that conform QBPlayerProtocol protocol
    ///   - currentTime: current time
    ///   - duration: video item duration
    func playerProgressUpdate(player:QBPlayerProtocol, currentTime:TimeInterval, duration:TimeInterval)
}

