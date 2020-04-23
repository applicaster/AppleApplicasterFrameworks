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
  };
  return manifest;
}
const min_zapp_sdk = {
  tvos: "12.2.0-Dev",
  ios: "20.2.0-Dev",
  android: "20.0.0-Dev",
};
const extra_dependencies = {
  ios: [
    {
      "ZappLocalNotifications": ":path => './node_modules/@applicaster/zapp_local_notifications/ZappLocalNotifications.podspec'",
    },
  ],
};
module.exports = createManifest;