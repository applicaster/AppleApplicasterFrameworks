#!/usr/bin/env node
// set -e

const {
  readPluginConfig,
  supportsApple,
  readAppleFrameworkName,
  abort
} = require("./Helpers.js");
const fs = require("fs");

function validateSinglePlugin(plugin) {
  // const frameworksList = readFrameworkDataPlist();
  console.log(`\nValidating plugin: '${plugin}'\n`);
  if (
    validateSinglePluginData(plugin) &&
    validateSinglePluginPathes(plugin)
  ) {
    console.log(`\n'${plugin}' is Valid`);
  } else {
    abort(
      `\nError: Framework: '${plugin}' Validation failed. \
      \nPlease check documentation in project repo and add missed items.`
    );
  }
}

function validateSinglePluginData(plugin) {
  const { name = null, version = null } = config = readPluginConfig(plugin);

  if (config.name && config.version) {
    console.log(
      `Plugin: '${plugin}' - All keys fetched correctly from 'package.json'`
    );
    return true;
  } else {
    console.log(
      `Plugin: '${plugin}': - 'package.json' does not exists`
    );
    return false;
  }
}

function validateSinglePluginPathes(plugin) {
  const { name = null, version = null, applicaster = null } = config = readPluginConfig(plugin);
  const baseFolderPath = `./${plugin}`
  console.log(
    `Validating required pathes for: ${plugin}'`
  );
  const succeedText = `framework: '${plugin}':All required files exist`;
  const isPlugin = fs.existsSync(`${baseFolderPath}/Templates/manifest.config.js`)
  const supportedPlatforms = config.applicaster.supportedPlatforms
  console.log(`is plugin: ${isPlugin}`)

  if (
    fs.existsSync(`${baseFolderPath}/Templates/.jazzy.yaml.ejs`) &&
    fs.existsSync(`${baseFolderPath}/.jazzy.yaml`) &&
    fs.existsSync(`${baseFolderPath}/Files`)
  ) {
    if (isPlugin == true) {
        if (
          supportsApple(plugin) &&
          readAppleFrameworkName(plugin)
        ) {
          console.log(succeedText);
          return true;
        }
        else {
          console.log(succeedText);
          return true;
        }
    } else if (
      supportsApple(plugin) &&
      readAppleFrameworkName(plugin)
    ) {
      console.log(succeedText);
      return true;
    }
  }
  return false;
}

module.exports = { validateSinglePlugin };
