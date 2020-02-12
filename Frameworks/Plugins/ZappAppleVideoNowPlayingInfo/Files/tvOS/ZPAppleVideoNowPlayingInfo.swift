//
//  ZPAppleVideoNowPlayingInfo.swift
//  ZappAppleVideoNowPlayingInfo for tvOS
//
//  Created by Alex Zchut on 05/02/2020.
//  Copyright © 2020 Applicaster Ltd. All rights reserved.
//

import ZappCore
import AVKit

class ZPAppleVideoNowPlayingInfo: ZPAppleVideoNowPlayingInfoBase {

    override func prepareNowPlayingInfo() {
        super.prepareNowPlayingInfo()
        
        guard let playerPlugin = playerPlugin,
            let entry = playerPlugin.entry else {
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

    func metadataItem(identifier : AVMetadataIdentifier, value : (NSCopying & NSObjectProtocol)?) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.value = value
        item.identifier = identifier
        item.extendedLanguageTag = "und" // undefined (wildcard) language
        return item
    }
}
