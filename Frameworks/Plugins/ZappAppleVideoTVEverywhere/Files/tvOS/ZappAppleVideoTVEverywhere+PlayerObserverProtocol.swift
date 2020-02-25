//
//  ZappAppleVideoTVEverywhere+PlayerObserverProtocol.swift
//  ZappAppleVideoTVEverywhere
//
//  Created by Jesus De Meyer on 24/02/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import Foundation
import AVKit
import ZappCore

extension ZappAppleVideoTVEverywhere {
    
    public override func playerDidCreate(player: PlayerProtocol) {
        //docs https://help.apple.com/itc/tvpumcstyleguide/#/itc0c92df7c9

        /*guard let entry = player.entry else {
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

        avPlayer?.currentItem?.externalMetadata = metadataItems*/
    }
}
