// @flow
import * as React from "react";
import * as R from "ramda";
import { View } from "react-native";
import { SsoBridge } from "./videoSubscriberSsoBridge";

type Props = {
  configuration: {},
  payload: {},
  callback: ({ success: boolean, error: ?{}, payload: ?{} }) => void,
};

export class SsoUiHook extends React.Component<Props> {
  construcstor(props) {
    super(props);
  }

  componentDidMount() {
      // Will be called once, when component finish logic
      SsoBridge.requestSso(callback) => {
        callback();
      }
      //Request
  }

  render() {
    return null
  }
}
