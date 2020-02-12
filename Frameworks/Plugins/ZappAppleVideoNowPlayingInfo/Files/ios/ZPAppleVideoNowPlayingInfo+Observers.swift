//
//  ZPAppleVideoNowPlayingInfo+Observers.swift
//  ZappAppleVideoNowPlayingInfo
//
//  Created by Alex Zchut on 11/02/2020.
//

import Foundation
import AVKit

extension ZPAppleVideoNowPlayingInfo {

    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {

        if let object = object as? AVPlayer,
            let player = avPlayer,
            object == player {

            //if playing
            if playbackStalled, player.rate > 0 {
                playbackStalled = false
            }
            //if paused
            else if !playbackStalled, player.rate == 0 {
                self.sendNowPlayingOnPause()
                playbackStalled = true
            }
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
}
