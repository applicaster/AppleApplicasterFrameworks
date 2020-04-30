/* @flow */

import React from "react";
import { Image, StyleSheet, Text, View, TouchableOpacity } from "react-native";

import GoogleCast from "./Cast";
import CastButtonComponent from "./CastButton";

export default class Main extends React.Component {
  constructor(props) {
    super(props);

    this.cast = this.cast.bind(this);
    this.sendMessage = this.sendMessage.bind(this);
    this.renderVideo = this.renderVideo.bind(this);
    this.subtitlesEnabled = false;

    this.state = {
      videos: [],
    };
  }

  componentDidMount() {
    console.log("Cast component mounted");
    this.registerListeners();

    GoogleCast.getCastState().then(console.log);
    // GoogleCast.showIntroductoryOverlay();
  }

  cast(video) {
    console.log("Cast video", video);

    GoogleCast.getCastDevice().then(console.log);
    GoogleCast.castMedia(video);
    GoogleCast.launchExpandedControls();
    // this.sendMessage();
  }

  onActionSelected = (position) => {
    console.log("Cast onActionSelected");

    switch (position) {
      case 0:
        GoogleCast.play();
        break;
      case 1:
        GoogleCast.pause();
        break;
      case 2:
        GoogleCast.stop();
        break;
      case 3:
        this.subtitlesEnabled = !this.subtitlesEnabled;
        GoogleCast.toggleSubtitles(this.subtitlesEnabled);
        break;
    }
  };

  render() {
    console.log("Cast render");

    return (
      <View style={styles.container}>
        <CastButtonComponent style={styles.CastButtonComponent} />
      </View>
    );
  }

  renderVideo({ item }) {
    console.log("Cast render video");

    const video = item;

    return (
      <TouchableOpacity
        key={video.title}
        onPress={() => this.cast(video)}
        style={{ flexDirection: "row", padding: 10 }}
      >
        <Image
          source={{ uri: video.imageUrl }}
          style={{ width: 160, height: 90 }}
        />
        <View style={{ flex: 1, marginLeft: 10, alignSelf: "center" }}>
          <Text style={{}}>{video.title}</Text>
          <Text style={{ color: "gray" }}>{video.studio}</Text>
        </View>
      </TouchableOpacity>
    );
  }

  registerListeners() {
    console.log("Cast registerListeners");

    const events = `
      SESSION_STARTING SESSION_STARTED SESSION_START_FAILED SESSION_SUSPENDED
      SESSION_RESUMING SESSION_RESUMED SESSION_ENDING SESSION_ENDED

      MEDIA_STATUS_UPDATED MEDIA_PLAYBACK_STARTED MEDIA_PLAYBACK_ENDED MEDIA_PROGRESS_UPDATED

      CHANNEL_CONNECTED CHANNEL_DISCONNECTED CHANNEL_MESSAGE_RECEIVED
    `
      .trim()
      .split(/\s+/);

    events.forEach((event) => {
      GoogleCast.EventEmitter.addListener(GoogleCast[event], function () {
        console.log(event, arguments);
      });
    });
  }

  sendMessage() {
    console.log("Cast sendMessage");
    const channel = "urn:x-cast:com.reactnative.googlecast.example";

    GoogleCast.initChannel(channel).then(() => {
      GoogleCast.sendMessage(channel, JSON.stringify({ message: "Hello" }));
    });
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "flex-start",
    alignItems: "stretch",
  },
  CastButtonComponent: {
    height: 24,
    width: 24,
    alignSelf: "flex-end",
    tintColor: "white",
  },
  stopButton: {
    alignSelf: "flex-end",
  },

  button: {
    paddingVertical: 5,
    paddingHorizontal: 10,
    borderRadius: 2,
    backgroundColor: "#42A5F5",
  },
  textButton: {
    color: "white",
    fontWeight: "bold",
  },
  chromeCastButtonComponent: {
    backgroundColor: "#EC407A",
    marginVertical: 10,
  },
  disconnectButton: {
    marginVertical: 10,
    backgroundColor: "#f44336",
  },
  controlButton: {
    marginVertical: 10,
    backgroundColor: "#689F38",
  },
});
