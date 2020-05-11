const { updateVersion } = require("./../../Scripts/manifestHelpers.js");

const baseManifest = {
  api: {},
  dependency_repository_url: [],
  author_name: "Applicaster",
  author_email: "zapp@applicaster.com",
  name: "App Center Crashlogs",
  description: "Zapp Crashlogs Plugin App Center",
  type: "error_monitoring",
  screen: false,
  react_native: false,
  identifier: "crashlogs_appcenter",
  ui_builder_support: true,
  whitelisted_account_ids: [],
  min_zapp_sdk: "0.0.1",
  deprecated_since_zapp_sdk: "",
  unsupported_since_zapp_sdk: "",
  custom_configuration_fields: [],
  npm_dependencies:[],
  targets: ["mobile"]
};

function createManifest({ identifier, version, platform, appleFrameworkName }) {
  const manifest = {
    ...baseManifest,
    platform,
    identifier,
    manifest_version: version,
    min_zapp_sdk: min_zapp_sdk[platform],
    extra_dependencies: updateIdentifier(identifier, extra_dependencies[platform]),
    api: api[platform],
    npm_dependencies: updateVersion(version, npm_dependencies[platform]),
    targets: targets[platform]
  };
  return manifest;
}
const min_zapp_sdk = {
  tvos: "14.1.0-Dev",
  ios: "12.0.0-Dev",
  tvos_for_quickbrick: "0.1.0-alpha1",
  ios_for_quickbrick: "0.1.0-alpha1"
};

const extra_dependencies_apple = {
  "##appleFrameworkName##": ":path => './node_modules/@applicaster/##identifier##/##appleFrameworkName##.podspec'"
};
const extra_dependencies = {
  ios: [
    extra_dependencies_apple
  ],
  ios_for_quickbrick: [
    extra_dependencies_apple
  ],
  tvos: [
    extra_dependencies_apple
  ],
  tvos_for_quickbrick: [
    extra_dependencies_apple
  ]
};

const api_apple = {
  "api": {
    "require_startup_execution": false,
    "class_name": "ZappCrashlogsMsAppCenter",
    "modules": [
      "ZappCrashlogsMsAppCenter"
    ]
  }
};
const api = {
  ios: [
    api_apple
  ],
  ios_for_quickbrick: [
    api_apple
  ],
  tvos: [
    api_apple
  ],
  tvos_for_quickbrick: [
    api_apple
  ]
};

const npm_dependencies_apple = {
  "@applicaster/##identifier##@##version##"
};
const npm_dependencies = {
  ios: [
    npm_dependencies_apple
  ],
  ios_for_quickbrick: [
    npm_dependencies_apple
  ],
  tvos: [
    npm_dependencies_apple
  ],
  tvos_for_quickbrick: [
    npm_dependencies_apple
  ]
};

const mobileTarget = ["mobile"]
const tvTarget = ["tv"]
const targets = {
  ios: [
    mobileTarget
  ],
  ios_for_quickbrick: [
    mobileTarget
  ],
  tvos: [
    tvTarget
  ],
  tvos_for_quickbrick: [
    tvTarget
  ]
};

module.exports = createManifest;
