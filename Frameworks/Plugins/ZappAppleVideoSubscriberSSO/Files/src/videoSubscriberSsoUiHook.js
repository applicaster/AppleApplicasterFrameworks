// @flow
import * as React from "react";
import * as R from "ramda";
import { View, StyleSheet, ActivityIndicator } from "react-native";
import { SsoBridge } from "./videoSubscriberSsoBridge";

type Props = {
  configuration: {},
  payload: {},
  callback: ({ success: boolean, error: ?{}, payload: ?{} }) => void,
};

export class SsoUiHook extends React.Component<Props> {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
      // Will be called once, when component finish logic
      SsoBridge.requestSso(callback) => {
        callback({ success: isSuccess, payload });
      }
      //Request
  }

  render() {
    const { payload, callback } = this.props;
    return null
  }
}
