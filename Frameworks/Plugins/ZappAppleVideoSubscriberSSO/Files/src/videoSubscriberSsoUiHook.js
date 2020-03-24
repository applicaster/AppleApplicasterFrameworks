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
    const {callback} = this.props
    // Will be called once, when component finish logic
    SsoBridge.requestSso(callback).then((result, error) => {
      callback({ success:result , error: error});
    }
  }

  render() {
    return null
  }
}
