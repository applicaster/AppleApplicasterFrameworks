//
//  ZPAppleVideoNowPlayingInfoBase+PlayerObserverProtocol.swift
//  ZappAppleVideoNowPlayingInfo
//
//  Created by Alex Zchut on 11/02/2020.
//

import Foundation
import ZappCore

extension ZPAppleVideoNowPlayingInfoBase: PlayerObserverProtocol {
    func playerDidFinishPlayItem(player: PlayerProtocol, completion: @escaping (Bool) -> Void) {
        //
    }
    
    func playerDidDismiss(player: PlayerProtocol) {
        //
    }
    
    func playerProgressUpdate(player: PlayerProtocol, currentTime: TimeInterval, duration: TimeInterval) {
        //
    }
    
    public func playerDidCreate(player: PlayerProtocol) {
        prepareNowPlayingInfo()
    }
}

