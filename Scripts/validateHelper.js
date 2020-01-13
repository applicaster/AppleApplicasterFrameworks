#!/usr/bin/env node

const {
  readFrameworkDataPlist,
  abort,
  basePathForModel
} = require("./Helpers.js");
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
    const baseFolderPath = basePathForModel(model);
    if (framework == frameworkToCheck) {
      const { framework = null, version_id = null } = model;
      searchedModel = framework && version_id && baseFolderPath ? model : null;
    }
  });
  searchedModel == null && console.log(failedText);

  return searchedModel;
}

function validateSingleFrameworkDataInPlist(model) {
  const baseFolderPath = basePathForModel(model);

  const { framework = null, version_id = null } = model;
  if (framework && version_id && baseFolderPath) {
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
  const baseFolderPath = basePathForModel(model);

  const { plugin, framework, npm_package } = model;
  console.log({ plugin });

  console.log(
    `Validating requiered pathes for Framework: ${framework}, Plugin:${plugin},  BasePath: '${baseFolderPath}'`
  );
  const succeedText = `framework: '${framework}':All required files exist`;
  if (
    fs.existsSync(baseFolderPath) &&
    fs.existsSync(`${baseFolderPath}/Templates/.jazzy.yaml.ejs`) &&
    fs.existsSync(`${baseFolderPath}/Templates/${framework}.podspec.ejs`) &&
    fs.existsSync(`${baseFolderPath}/.jazzy.yaml`) &&
    fs.existsSync(`${baseFolderPath}/Podfile`) &&
    fs.existsSync(`${baseFolderPath}/Files`)
  ) {
    if (plugin == true) {
      if (
        ((fs.existsSync(`${baseFolderPath}/Templates/ios.json.ejs`) ||
          fs.existsSync(`${baseFolderPath}/Templates/tvos.json.ejs`)) &&
          fs.existsSync(`${baseFolderPath}/Manifest/ios.json`)) ||
        fs.existsSync(`${baseFolderPath}/Manifest/tvos.json`)
      ) {
        if (
          (npm_package &&
            fs.existsSync(`${baseFolderPath}/Files/${framework}.podspec`)) ||
          (!npm_package && fs.existsSync(`${framework}.podspec`))
        ) {
          console.log(succeedText);
          return true;
        }
      }
    } else {
      if (fs.existsSync(`${framework}.podspec`)) {
        console.log(succeedText);
        return true;
      }
    }
  }
  return false;
}

module.exports = { validateSingleFramework };
