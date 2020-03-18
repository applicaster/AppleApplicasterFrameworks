//
//  UNNotificationAttachment+Payload.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/16/20.
//

import Foundation
import ZappCore

extension UNNotificationAttachment {
    class func attachments(payload: [AnyHashable: Any]) -> [UNNotificationAttachment] {
        var retVal: [UNNotificationAttachment] = []
        guard let attachments = payload[LocalNotificationPayloadConst.attachments] as? [[AnyHashable: String]],
            attachments.isEmpty == false else {
            return retVal
        }

        for attachment in attachments {
            if let url = urlForAttachment(attachment: attachment),
                let attachment = try? UNNotificationAttachment(identifier: url.path,
                                                               url: url,
                                                               options: .none) {
                retVal.append(attachment)

                // Limit 1 availible attachment
                break
            }
        }

        return retVal
    }

    class func urlForAttachment(attachment: [AnyHashable: String]) -> URL? {
        if let fileName = attachment[LocalNotificationPayloadAttachments.iosOverrideImageUri],
            let url = urlFromUri(uri: fileName) {
            return url
        } else if let fileName = attachment[LocalNotificationPayloadAttachments.imageUri],
            let url = urlFromUri(uri: fileName) {
            return url
        }
        return nil
    }

    class func urlFromUri(uri: String) -> URL? {
        let fileNameNoWhiteSpaces = uri.replace(" ",
                                                withString: "")
        if let url = Bundle.main.url(forResource: fileNameNoWhiteSpaces,
                                     withExtension: ""),
            FileManager().fileExists(atPath: url.path) {
            return url
        }
        return nil
    }
}
