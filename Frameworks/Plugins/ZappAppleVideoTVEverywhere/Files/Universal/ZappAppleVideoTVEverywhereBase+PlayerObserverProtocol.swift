//
//  ZappAppleVideoTVEverywhereBase+PlayerObserverProtocol.swift
//  ZappAppleVideoTVEverywhere
//
//  Created by Jesus De Meyer on 24/02/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation
import ZappCore

extension ZappAppleVideoTVEverywhereBase: PlayerObserverProtocol {
    func playerDidFinishPlayItem(player: PlayerProtocol, completion: @escaping (Bool) -> Void) {
        //implement in child classes
    }
    
    func playerDidDismiss(player: PlayerProtocol) {
        //implement in child classes
    }
    
    func playerProgressUpdate(player: PlayerProtocol, currentTime: TimeInterval, duration: TimeInterval) {
        //implement in child classes
    }
    
    public func playerDidCreate(player: PlayerProtocol) {
        //implement in child classes
    }
}

