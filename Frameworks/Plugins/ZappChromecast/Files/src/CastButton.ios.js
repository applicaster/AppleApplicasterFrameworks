import React from "react";
import { requireNativeComponent, NativeModules } from "react-native";

type Props = {
  key: string,
  color: string,
};

function Component(props: Props) {
  const styles = { flex: 1 };
  if (CastButtonComponent) {
    return <CastButtonComponent style={styles} {...props} />;
  } else {
    return null;
  }
}

Component.propTypes = {
  /**
   * A flag that indicates whether a touch event on this button will trigger the display of the Cast dialog that is provided by the framework.
   *
   * By default this property is set to YES. If an application wishes to handle touch events itself, it should set the property to NO and register an appropriate target and action for the touch event.
   * */
  // triggersDefaultCastDialog: PropTypes.bool
  // accessibilityLabel: PropTypes.string
};

var CastButtonComponent = requireNativeComponent(
  "ChromecastButton",
  Component,
  {
    nativeOnly: {
      accessibilityLabel: true,
      accessibilityLiveRegion: true,
      accessibilityComponentType: true,
      testID: true,
      nativeID: true,
      importantForAccessibility: true,
      renderToHardwareTextureAndroid: true,
      onLayout: true,
    },
  }
);

export { Component };
