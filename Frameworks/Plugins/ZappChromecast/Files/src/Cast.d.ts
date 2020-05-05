declare module "react-native-google-cast" {
  import * as React from "react";
  import { ViewProps } from "react-native";

  export type CastState =
    | "NoDevicesAvailable"
    | "NotConnected"
    | "Connecting"
    | "Connected";

  export type Media = {
    title: string;
    subtitle: string;
    studio: string;
    duration: number;
    mediaUrl: string;
    imageUrl: string;
    posterUrl: string;
    analytics: {
      feedId: string;
      feedUrl: string;
      feedTitle: string;
      entryId: string;
      itemName: string;
      vodType: string;
      free: boolean;
    };
  };

  export type Props = {
    originKey: string;
    colorKey: string;
  };

  const GoogleCast: {
    getCastState(): Promise<CastState>;
    castMedia(params: Media): void;
    hasConnectedCastSession(): Promise<boolean>;
    play(): void;
    pause(): void;
    stop(): void;
    seek(playPosition: number): void;
    launchExpandedControls(): void;
    showIntroductoryOverlay(): void;
    setVolume(volume: number): void;
  };

  export default GoogleCast;

  export function Component(props: Props): React.Component {}
}
