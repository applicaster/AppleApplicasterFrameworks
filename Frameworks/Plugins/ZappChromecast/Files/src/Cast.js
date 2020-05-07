// @flow

import {
  NativeModules,
  Platform,
  DeviceEventEmitter,
  NativeEventEmitter,
} from "react-native";

import { Component } from "./CastButton";
const { RNGoogleCast: GoogleCast, RNGoogleCastEventEmitter } = NativeModules;

const EventClass =
  Platform.OS === "ios" ? RNGoogleCastEventEmitter : GoogleCast;

console.log({ EventClass, RNGoogleCastEventEmitter, GoogleCast });

type CastState =
  | "NoDevicesAvailable"
  | "NotConnected"
  | "Connecting"
  | "Connected";

type Media = {
  title: string,
  subtitle: string,
  studio: string,
  duration: number,
  mediaUrl: string,
  imageUrl: string,
  posterUrl: string,
  analytics: {
    feedId: string,
    feedTitle: string,
    entryId: string,
    itemName: string,
    vodType: string,
    free: boolean,
  },
};

const CAST_STATES = [
  "NoDevicesAvailable",
  "NotConnected",
  "Connecting",
  "Connected",
];

export default {
  /**
   * Native chromecast button component
   */
  Component,

  /**
   * Sends a media item to be casted to the native module.
   * @param {object} Media
   * @returns {Promise} resolves with a boolean, rejects with error.
   */
  castMedia(params: Media): Promise<any> {
    return GoogleCast.castMedia(params);
  },

  /**
   * Gets cast state of the device from native module.
   * @returns {string} CastState
   */
  getCastState(): CastState {
    return GoogleCast.getCastState().then((state) => {
      return CAST_STATES[state];
    });
  },

  /**
   * Returns whether the device is connected and ready to cast from native module.
   * Sets the value of this.castingState
   * @returns {boolean}
   */
  hasConnectedCastSession(): boolean {
    console.log("checkIf-hasConnectedCastSession");
    GoogleCast.hasConnectedCastSession().then((casting) => {
      console.log("responseFrom-hasConnectedCastSession", casting);

      this.castingState = casting;
    });
    return this.castingState;
  },

  /**
   * Returns whether the value of this.castingState which determines if device is connected.
   * Triggers hasConnectedCastSession method to retreive this data from the native.
   * @returns {boolean} this.castingState
   */
  get isCasting(): boolean {
    this.hasConnectedCastSession();
    return this.castingState;
  },

  /**
   * Stores the last known cast state of the device.
   */
  castingState: false,

  /**
   * Begins (or resumes) playback of the current media item.
   */
  play: GoogleCast.play,

  /**
   * Pauses playback of the current media item.
   */
  pause: GoogleCast.pause,

  /**
   * Stops playback of the current media item.
   */
  stop: GoogleCast.stop,

  /**
   * Seeks to a new position within the current media item.
   *
   * @param {number} playPosition
   * @returns {*}
   */
  seek(playPosition: number) {
    return GoogleCast.seek(playPosition);
  },

  /**
   * Sets playback volume on the device.
   *
   * @param {number} volume
   * @returns {*}
   */
  setVolume(volume: number) {
    return GoogleCast.setVolume(volume);
  },

  /**
   * Sends request to native module to render expanded media controls view.
   */
  launchExpandedControls: GoogleCast.launchExpandedControls,

  /**
   * Sends request to native module to render introductory demo view.
   * This view explains to users how to cast to device.
   */
  showIntroductoryOverlay: GoogleCast.showIntroductoryOverlay,

  /**
   * Events
   */
  EventEmitter:
    Platform.OS === "ios"
      ? new NativeEventEmitter(EventClass)
      : DeviceEventEmitter,
  CAST_STATE_CHANGED: EventClass.CAST_STATE_CHANGED,
  SESSION_STARTED: EventClass.SESSION_STARTED,
  SESSION_START_FAILED: EventClass.SESSION_START_FAILED,
  SESSION_SUSPENDED: EventClass.SESSION_SUSPENDED,
  SESSION_RESUMING: EventClass.SESSION_RESUMING,
  SESSION_RESUMED: EventClass.SESSION_RESUMED,
  SESSION_ENDING: EventClass.SESSION_ENDING,
  SESSION_ENDED: EventClass.SESSION_ENDED,
  MEDIA_STATUS_UPDATED: EventClass.MEDIA_STATUS_UPDATED,
  MEDIA_PLAYBACK_STARTED: EventClass.MEDIA_PLAYBACK_STARTED,
  MEDIA_PLAYBACK_ENDED: EventClass.MEDIA_PLAYBACK_ENDED,
  MEDIA_PROGRESS_UPDATED: EventClass.MEDIA_PROGRESS_UPDATED,
  CHANNEL_CONNECTED: EventClass.CHANNEL_CONNECTED,
  CHANNEL_DISCONNECTED: EventClass.CHANNEL_DISCONNECTED,
  CHANNEL_MESSAGE_RECEIVED: EventClass.CHANNEL_MESSAGE_RECEIVED,
};
