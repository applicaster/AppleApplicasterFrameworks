// @flow

import { NativeModules } from "react-native";

import { Component } from "./CastButton";
const { RNGoogleCast: GoogleCast } = NativeModules;

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
    feedUrl: string,
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
   * @returns {*}
   */
  castMedia(params: Media) {
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
   * Sets the value of this.casting
   * @returns {boolean}
   */
  isCasting(): boolean {
    GoogleCast.hasConnectedCastSession().then((casting) => {
      return casting;
    });
  },

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
};
