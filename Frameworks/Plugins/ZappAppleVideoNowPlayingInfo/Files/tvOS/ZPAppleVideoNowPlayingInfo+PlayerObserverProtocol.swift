//
//  ZPAppleVideoNowPlayingInfo+Observers.swift
//  ZappAppleVideoNowPlayingInfo
//
//  Created by Alex Zchut on 11/02/2020.
//

import Foundation
import AVKit
import ZappCore

extension ZPAppleVideoNowPlayingInfo {
    
    public override func playerDidCreate(player: PlayerProtocol) {
        //docs https://help.apple.com/itc/tvpumcstyleguide/#/itc0c92df7c9

        guard let entry = player.entry else {
            return
        }

        guard let title = entry[ItemMetadata.title] as? (NSCopying & NSObjectProtocol),
            let contentId = entry[ItemMetadata.contentId] as? (NSCopying & NSObjectProtocol) else {
                return
        }

        var metadataItems: [AVMetadataItem] = [AVMetadataItem]()
        metadataItems.append(self.metadataItem(identifier: AVMetadataIdentifier.commonIdentifierTitle,
                                          value: title))
        metadataItems.append(self.metadataItem(identifier: AVMetadataIdentifier(rawValue: AVKitMetadataIdentifierExternalContentIdentifier),
                                          value: contentId))
        metadataItems.append(self.metadataItem(identifier: AVMetadataIdentifier(rawValue: AVKitMetadataIdentifierPlaybackProgress),
                                          value: NSNumber(integerLiteral: 0)))

        avPlayer?.currentItem?.externalMetadata = metadataItems
    }
}
