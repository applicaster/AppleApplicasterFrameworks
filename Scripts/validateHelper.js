#!/usr/bin/env node

const { readFrameworkDataPlist, abort } = require("./Helpers.js");
const fs = require("fs");

function validateSingleFramework(frameworkToCheck) {
  const frameworksList = readFrameworkDataPlist();
  console.log(`\nValidating Framework: '${frameworkToCheck}'\n`);

  let pluginData = frameworkModelFrom(frameworksList, frameworkToCheck);

  if (
    pluginData &&
    validateSingleFrameworkDataInPlist(pluginData) &&
    validateSingleFrameworkPathes(pluginData)
  ) {
    console.log(`\n'${frameworkToCheck}' is Valid`);
  } else {
    abort(
      `\nError: Framework: '${frameworkToCheck}' Validation failed. \
      \nPlease check documentation in project repo and add missed items.`
    );
  }
}

function frameworkModelFrom(frameworksList, frameworkToCheck) {
  const failedText = `Framework: '${frameworkToCheck}' does not exist`;
  let searchedModel = null;

  frameworksList.forEach(model => {
    const { framework = null } = model;
    if (framework == frameworkToCheck) {
      const {
        framework = null,
        version_id = null,
        folder_path = null,
        is_plugin = null
      } = model;
      searchedModel =
        framework && version_id && folder_path && is_plugin != null
          ? model
          : null;
    }
  });
  searchedModel == null && console.log(failedText);

  return searchedModel;
}

function validateSingleFrameworkDataInPlist(model) {
  const {
    framework = null,
    version_id = null,
    folder_path = null,
    is_plugin = null
  } = model;
  if (framework && version_id && folder_path && is_plugin != null) {
    console.log(
      `Framework: '${framework}' All keys was defined in 'FrameworksData.plist'`
    );
    return true;
  } else {
    console.log(
      "Framework: '${framework}': Required data in 'FrameworksData.plist' does not exists"
    );
    return false;
  }
}

function validateSingleFrameworkPathes(model) {
  const { folder_path, is_plugin, framework } = model;

  const succeedText = `framework: '${framework}':All required files exist`;
  if (
    fs.existsSync(folder_path) &&
    fs.existsSync(`${folder_path}/Templates/.jazzy.yaml.ejs`) &&
    fs.existsSync(`${folder_path}/Templates/${framework}.podspec.ejs`) &&
    fs.existsSync(`${framework}.podspec`) &&
    fs.existsSync(`${folder_path}/Project/.jazzy.yaml`) &&
    fs.existsSync(`${folder_path}/Project/README.md`) &&
    fs.existsSync(`${folder_path}/Files`)
  ) {
    if (is_plugin == true) {
      if (
        ((fs.existsSync(`${folder_path}/Templates/ios.json.ejs`) ||
          fs.existsSync(`${folder_path}/Templates/tvos.json.ejs`)) &&
          fs.existsSync(`${folder_path}/Manifest/ios.json`)) ||
        fs.existsSync(`${folder_path}/Manifest/tvos.json`)
      ) {
        console.log(succeedText);
        return true;
      }
    } else {
      console.log(succeedText);
      return true;
    }
  }
  return false;
}

module.exports = { validateSingleFramework };
