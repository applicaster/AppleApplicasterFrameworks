//
//  ZPAppleVideoSubscriberSSO.swift
//  ZappAppleVideoSubscriberSSO for iOS
//
//  Created by Alex Zchut on 22/03/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import ZappCore
import AVKit

class ZPAppleVideoSubscriberSSO: NSObject {

    override func disable(completion: ((Bool) -> Void)?) {
        avPlayer?.removeObserver(self,
                                 forKeyPath: "rate",
                                 context: nil)

        unregisterForRemoteCommands()

        super.disable(completion: completion)
    }

    func registerForRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
             // pause your player
             return .success
        }
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.seekForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
             // seek forward
             return .success
        }
        commandCenter.seekBackwardCommand.isEnabled = true
        commandCenter.seekBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
             // seek backward
             return .success
        }
    }

    func unregisterForRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.pauseCommand.isEnabled = false
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.seekBackwardCommand.isEnabled = false
        commandCenter.seekBackwardCommand.removeTarget(nil)
        commandCenter.seekForwardCommand.isEnabled = false
        commandCenter.seekForwardCommand.removeTarget(nil)
    }

    func disableNowPlayingUpdates() {
        if let avPlayerViewController = self.playerPlugin?.pluginPlayerViewController as? AVPlayerViewController {
            avPlayerViewController.updatesNowPlayingInfoCenter = false
        }
    }

    func sendNowPlayingInitial(player: PlayerProtocol) {
        guard let entry = player.entry else {
            return
        }

        guard let title = entry[ItemMetadata.title] as? (NSCopying & NSObjectProtocol),
            let contentId = entry[ItemMetadata.contentId] as? (NSCopying & NSObjectProtocol) else {
                return
        }

        logger = NowPlayingLogger()
        logger?.start()

        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.playbackDuration()
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.playbackPosition()
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        nowPlayingInfo[MPNowPlayingInfoPropertyExternalContentIdentifier] = contentId
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = 0.0

        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }

    func sendNowPlayingOnPause() {
        guard let playerPlugin = playerPlugin else {
            return
        }

        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = nowPlayingInfoCenter.nowPlayingInfo
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerPlugin.playbackPosition()
        nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
    }
}
