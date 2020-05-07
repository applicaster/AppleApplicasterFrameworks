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
        static let SESSION_STARTED = "GoogleCast:SessionStarted"
        static let SESSION_START_FAILED = "GoogleCast:SessionStartFailed"
        static let SESSION_SUSPENDED = "GoogleCast:SessionSuspeneded"
        static let SESSION_RESUMING = "GoogleCast:SessionResuming"
        static let SESSION_RESUMED = "GoogleCast:SessionResumed"
        static let SESSION_ENDING = "GoogleCast:SessionEnding"
        static let MEDIA_STATUS_UPDATED = "GoogleCast:MediaStatusUpdated"
        static let MEDIA_PLAYBACK_STARTED = "GoogleCast:MediaPlaybackStarted"
        static let MEDIA_PLAYBACK_ENDED = "GoogleCast:MediaPlaybackEnded"
        static let MEDIA_PROGRESS_UPDATED = "GoogleCast:MediaProgressUpdated"
        static let CHANNEL_CONNECTED = "GoogleCast:ChannelConnected"
        static let CHANNEL_DISCONNECTED = "GoogleCast:ChannelDisconnected"
        static let CHANNEL_MESSAGE_RECEIVED = "GoogleCast:ChannelMessageReceived"
    }
    
    override init() {
        super.init()
        RNEventEmitter.emitter = self
    }

    open override func supportedEvents() -> [String] {
        [
            RNEventEmitter.Events.CAST_STATE_CHANGED,
            RNEventEmitter.Events.SESSION_STARTED
            RNEventEmitter.Events.SESSION_START_FAILED
            RNEventEmitter.Events.SESSION_SUSPENDED
            RNEventEmitter.Events.SESSION_RESUMING
            RNEventEmitter.Events.SESSION_RESUMED
            RNEventEmitter.Events.SESSION_ENDING
            RNEventEmitter.Events.MEDIA_STATUS_UPDATED
            RNEventEmitter.Events.MEDIA_PLAYBACK_STARTED
            RNEventEmitter.Events.MEDIA_PLAYBACK_ENDED
            RNEventEmitter.Events.MEDIA_PROGRESS_UPDATED
            RNEventEmitter.Events.CHANNEL_CONNECTED
            RNEventEmitter.Events.CHANNEL_DISCONNECTED
            RNEventEmitter.Events.CHANNEL_MESSAGE_RECEIVED
            ]
    }
}
