#!/usr/bin/env node

const fs = require("fs");
const { readFrameworkDataPlist, proccessArgs, abort } = require("./Helpers.js");

const frameworksList = readFrameworkDataPlist();
const args = proccessArgs();
if (args.length == 0) {
  abort("Error: expected argument Framework was not passed");
}
const frameworkToCheck = args[0];
console.log(`Validating Framework:${frameworkToCheck}`);

var isAllPathesValid = false;
let pluginData = null;
frameworksList.forEach(model => {
  const {
    framework = null,
    version_id = null,
    folder_path = null,
    is_plugin = null
  } = model;

  if (framework == null) {
    console.log("ERROR: Argument 'framework' did not provided in plist");
  } else if (framework == frameworkToCheck) {
    if (version_id == null) {
      console.log("ERROR: Argument 'version_id' did not provided in plist");
    }

    if (folder_path == null) {
      console.log("ERROR: Argument 'folder_path' did not provided in plist");
    }

    if (is_plugin == null) {
      console.log("ERROR: Argument 'is_plugin' did not provided in plist");
    }

    if (version_id != null && folder_path != null && is_plugin != null) {
      isFrameworkDefinedInPlist = true;
      pluginData = {
        framework,
        version_id,
        folder_path,
        is_plugin
      };
    }
  }
});

if (pluginData == null) {
  console.log("\nPlease define your framework in 'FrameworksData.plist'");
  console.log(
    "Mandatory keys: {framework:'MyFramework', version:'1.0.0', folder_path:'Frameworks/MyFramework, is_plugin:false'}"
  );
  console.log("\nKey:'framework' - Name of the framework");
  console.log("Key:'version' - Version of the framework");
  console.log(
    "Key:'folder_path' - Base path to the framework. Example: `Frameworks/Plugins/Analytics/GoogleAnalytics`"
  );
  console.log(
    "Key:'is_plugin' - Define if framework is a plugin. Value true inform publisher task that this plugin has manifests and need to be uploaded to Zapp"
  );
} else {
  const { folder_path = null, is_plugin = null } = pluginData;
  console.log(
    `Framework: '${frameworkToCheck}' all keys was defined in 'FrameworksData.plist'`
  );
  let filesNotDefined = false;

  if (fs.existsSync(folder_path) == false) {
    console.log(
      `Error: Framework does not exist in defined path: ${folder_path}`
    );
    filesNotDefined = true;
  }

  if (fs.existsSync(`${folder_path}/Templates/template_jazzy.yaml`) == false) {
    console.log(
      `Error: 'template_jazzy.yaml' template yaml does not exist in required path: '${folder_path}/Templates/template_jazzy.yaml'`
    );
    filesNotDefined = true;
  }

  if (
    fs.existsSync(
      `${folder_path}/Templates/template_${frameworkToCheck}.podspec`
    ) == false
  ) {
    console.log(
      `Error: 'template_${frameworkToCheck}.podspec' does not exist in required path: '${folder_path}/Templates/template_${frameworkToCheck}.podspec'`
    );
    filesNotDefined = true;
  }

  if (is_plugin == true) {
    if (
      fs.existsSync(`${folder_path}/Templates/template_ios.json`) == false &&
      fs.existsSync(`${folder_path}/Templates/template_tvos.json`) == false
    ) {
      console.log(
        "Error: Plugin must has at least one manifest for iOS or tvOS"
      );
      console.log(
        `Expected pathes ios: ${folder_path}/Templates/template_ios.json\ntvos:${folder_path}/Templates/template_tvos.json`
      );
      filesNotDefined = true;
    }

    if (
      fs.existsSync(`${folder_path}/Manifest/ios.json`) == false &&
      fs.existsSync(`${folder_path}/Manifest/tvos.json`) == false
    ) {
      console.log(
        "Error: Plugin must has at least one manifest for iOS or tvOS"
      );
      console.log(
        `Expected pathes:\nios: ${folder_path}/Manifest/ios.json\ntvos:${folder_path}/Manifest/tvos.json`
      );
      filesNotDefined = true;
    }
  }

  if (fs.existsSync(`${frameworkToCheck}.podspec`) == false) {
    console.log(
      `Error: '${frameworkToCheck}.podspec' does not exist in required path: './${frameworkToCheck}.podspec'`
    );
    filesNotDefined = true;
  }

  if (fs.existsSync(`${folder_path}/Project/.jazzy.yaml`) == false) {
    console.log(
      `Error: '.jazzy.yaml' does not exist in required path: '${folder_path}/Project/.jazzy.yaml'`
    );
    filesNotDefined = true;
  }

  if (fs.existsSync(`${folder_path}/Project/README.md`) == false) {
    console.log(
      `Error: 'README.md' does not exist in required path: '${folder_path}/Project/README.md'`
    );
    filesNotDefined = true;
  }

  if (fs.existsSync(`${folder_path}/Files`) == false) {
    console.log(`Error: Folder does not exist required path: ${folder_path}`);
    filesNotDefined = true;
  }

  if (filesNotDefined == false) {
    isAllPathesValid = true;
    console.log(`All required files exist for framework: ${frameworkToCheck}`);
  }
}

if (isAllPathesValid == true && pluginData) {
  console.log(`\n'${frameworkToCheck}' is Valid`);
} else {
  abort(`\nError: '${frameworkToCheck}' Validation failed`);
}
