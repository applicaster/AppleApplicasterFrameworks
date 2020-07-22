const min_zapp_sdk = {
  ios: "20.0.0-Dev",
  android: "20.0.0-Dev",
  ios_for_quickbrick: "0.1.0-alpha1",
  android_for_quickbrick: "0.1.0-alpha1",
};

const baseManifest = {
  api: {},
  dependency_repository_url: [],
  dependency_name: "@applicaster/zapp-generic-chromecast",
  author_name: "Applicaster",
  author_email: "zapp@applicaster.com",
  name: "Chromecast (QB)",
  description:
    "A react native plugin that allows you to add chromecast support to a QuickBrick based project",
  type: "general",
  preload: true,
  react_native: true,
  identifier: "chromecast_qb",
  ui_builder_support: true,
  whitelisted_account_ids: [
    "5ae06cef8fba0f00084bd3c6",
    "572a0a65373163000b000000",
  ],
  general: {},
  data: {},
  custom_configuration_fields: [
    {
      type: "text",
      key: "chromecast_app_id",
      tooltip_text: "Chromecast application ID",
    },
  ],
  styles: {},
  targets: ["mobile"],
  ui_frameworks: ["quickbrick"],
};

function createManifest({ version, platform }) {
  const manifest = {
    ...baseManifest,
    platform,
    dependency_version: version,
    manifest_version: version,
    min_zapp_sdk: min_zapp_sdk[platform],
    npm_dependencies: [`@applicaster/zapp-generic-chromecast@${version}`],
  };

  if (platform.includes("android")) {
    manifest.api = {
      require_startup_execution: false,
      class_name: "com.applicaster.chromecast.ChromeCastPlugin",
      react_packages: ["com.reactnative.googlecast.GoogleCastPackage"],
      proguard_rules: "-keep public class com.reactnative.googlecast.** {*;}",
    };

    manifest.project_dependencies = [
      {
        "react-native-google-cast":
          "./node_modules/@applicaster/zapp-generic-chromecast/android/",
      },
    ];

    manifest.extra_dependencies = [];
  }

  if (platform.includes("ios")) {
    manifest.extra_dependencies = [
      {
        ZappChromecast:
          ":path =\u003e './node_modules/@applicaster/zapp-generic-chromecast/ZappChromecast.podspec'",
      },
    ];

    manifest.api = {
      require_startup_execution: true,
      class_name: "ChromecastAdapter",
      modules: ["ZappChromecast"],
    };
  }

  return manifest;
}

module.exports = createManifest;
