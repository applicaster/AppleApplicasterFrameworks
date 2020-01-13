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
  let pluginData = frameworksList[frameworkToCheck];
  console.log({ pluginData });
  pluginData["framework"] = frameworkToCheck;
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

function validateSingleFrameworkDataInPlist(model) {
  const baseFolderPath = basePathForModel(model);

  const { version_id = null, framework = null } = model;
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

  const { plugin = null, npm_package = null, framework = null } = model;
  console.log({ model, framework });

  console.log(
    `Validating requiered pathes for Framework: ${framework}, Plugin:${plugin},  BasePath: '${baseFolderPath}'`
  );
  const succeedText = `framework: '${framework}':All required files exist`;
  console.log(
    fs.existsSync(baseFolderPath) &&
      fs.existsSync(`${baseFolderPath}/Templates/.jazzy.yaml.ejs`) &&
      fs.existsSync(`${baseFolderPath}/Templates/${framework}.podspec.ejs`) &&
      fs.existsSync(`${baseFolderPath}/.jazzy.yaml`) &&
      fs.existsSync(`${baseFolderPath}/Podfile`) &&
      fs.existsSync(`${baseFolderPath}/Files`)
  );
  if (
    fs.existsSync(baseFolderPath) &&
    fs.existsSync(`${baseFolderPath}/Templates/.jazzy.yaml.ejs`) &&
    fs.existsSync(`${baseFolderPath}/Templates/${framework}.podspec.ejs`) &&
    fs.existsSync(`${baseFolderPath}/.jazzy.yaml`) &&
    fs.existsSync(`${baseFolderPath}/Podfile`) &&
    fs.existsSync(`${baseFolderPath}/Files`)
  ) {
    console.log("HERE!");
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
