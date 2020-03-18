//
//  AttachmentsTestDummies.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/18/20.
//

import Foundation

let attachment_dummy_empty: [AnyHashable: Any] = [:]

let attachment_dummy_empty_attachments: [AnyHashable: Any] = [
    "attachments": [],
]

let attachment_dummy_data: [AnyHashable: Any] = [
    "attachments": [
        ["uri": "image.png"],
    ],
]

let attachment_dummy_data_two_items: [AnyHashable: Any] = [
    "attachments": [
        ["uri": "image.png"],
        ["uri": "video.mp4"],
    ],
]

let attachment_dummy_data_no_items: [AnyHashable: Any] = [
    "attachments": [
        [],
    ],
]

let attachment_dummy_data_uri_number: [AnyHashable: Any] = [
    "attachments": [
        ["uri": 123],
    ],
]

let attachment_dummy_data_no_extension: [AnyHashable: Any] = [
    "attachments": [
        ["uri": "image"],
    ],
]

let attachment_dummy_data_url: [AnyHashable: Any] = [
    "attachments": [
        ["uri": "https://www.google.com/images/test.png"],
    ],
]
