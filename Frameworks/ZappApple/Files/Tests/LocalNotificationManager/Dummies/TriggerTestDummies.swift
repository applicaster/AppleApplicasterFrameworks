//
//  TriggerTestDummies.swift
//  ZappApple
//
//  Created by Anton Kononenko on 3/18/20.
//

import Foundation

let trigger_no_timestamp: [AnyHashable: Any] = [:]

let trigger_timestamp: [AnyHashable: Any] = [
    "unixTimestamp": 32503726800,
]

let trigger_timestamp_double: [AnyHashable: Any] = [
    "unixTimestamp": 32503726800.33,
]


let trigger_timestamp_string: [AnyHashable: Any] = [
    "unixTimestamp": "32503726800",
]

let trigger_timestamp_corrupted: [AnyHashable: Any] = [
    "unixTimestamp": "A1b7-test",
]

let trigger_timestamp_old: [AnyHashable: Any] = [
    "unixTimestamp": 946731600,
]
