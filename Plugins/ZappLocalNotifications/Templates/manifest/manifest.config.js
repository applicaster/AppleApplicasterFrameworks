const baseManifest = {
  api: {},
  dependency_repository_url: [],
  dependency_name: "@applicaster/zapp_local_notifications",
  author_name: "Applicaster",
  author_email: "zapp@applicaster.com",
  name: "Generic Local Notifications",
  description: "Generic Local Notifications",
  type: "general",
  screen: false,
  react_native: false,
  identifier: "generic_local_notifications",
  ui_builder_support: true,
  whitelisted_account_ids: ["5e39259919785a0008225336"],
  min_zapp_sdk: "0.0.1",
  deprecated_since_zapp_sdk: "",
  unsupported_since_zapp_sdk: "",
  preload: true,
  custom_configuration_fields: [],
  npm_dependencies:[],
  targets: ["mobile"],
  ui_frameworks: ["quickbrick"]
};

function createManifest({ version, platform }) {
  const manifest = {
    ...baseManifest,
    platform,
    dependency_version: version,
    manifest_version: version,
    min_zapp_sdk: min_zapp_sdk[platform],
    extra_dependencies: extra_dependencies[platform],
    api: api[platform],
    npm_dependencies: npm_dependencies[platform]
  };
  return manifest;
}
const min_zapp_sdk = {
  tvos_for_quickbrick: "0.1.0-alpha1",
  ios_for_quickbrick: "0.1.0-alpha1",
  android_for_quickbrick: "0.1.0-alpha1",
};
const extra_dependencies = {
  ios_for_quickbrick: [
    {
      "ZappLocalNotifications": ":path => './node_modules/@applicaster/zapp_local_notifications/ZappLocalNotifications.podspec'",
    },
  ],
  tvos_for_quickbrick: [
    {
      "ZappLocalNotifications": ":path => './node_modules/@applicaster/zapp_local_notifications/ZappLocalNotifications.podspec'",
    },
  ],
};
const api = {
  ios_for_quickbrick: [
    {
      "class_name": "LocalNotificationManager",
      "modules": [
        "ZappLocalNotifications"
      ]
    },
  ],
  tvos_for_quickbrick: [
    {
      "class_name": "LocalNotificationManager",
      "modules": [
        "ZappLocalNotifications"
      ]
    },
  ],
  android_for_quickbrick: [
    {
      "class_name": "com.applicaster.reactnative.plugins.APReactNativeAdapter",
      "react_packages": [
        "com.applicaster.localnotifications.reactnative.LocalNotificationPackage"
      ]
    },
  ],
};
const npm_dependencies = {
  ios_for_quickbrick: [
    {
      "@applicaster/zapp_local_notifications@<%= version_id %>"
    },
  ],
  tvos_for_quickbrick: [
    {
      "@applicaster/zapp_local_notifications@<%= version_id %>"
    },
  ],
};
module.exports = createManifest;