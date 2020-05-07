//
//  RNEventEmitter.swift
//  ZappChromecast
//
//  Created by Alex Zchut on 05/05/2020.
//

import Foundation
import React

@objc(RNGoogleCastEventEmitter)
open class RNEventEmitter: RCTEventEmitter {
    public static var emitter: RCTEventEmitter!
    
    public struct Events {
        static let CAST_STATE_CHANGED = "GoogleCast:CastStateChanged"
    }
    
    override init() {
        super.init()
        RNEventEmitter.emitter = self
    }
    
    open override func supportedEvents() -> [String] {
        return ["GoogleCast:CastStateChanged"]
    }
}
