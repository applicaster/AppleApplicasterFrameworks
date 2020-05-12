#!/usr/bin/env node
const fs = require("fs");
const {
  readPluginsList,
  readPluginConfig
} = require("./helpers.js");
const {
  validateSupportedPlatforms
} = require("./validatePluginsHelper.js");

const pluginsList = readPluginsList();
pluginsList.forEach(plugin => {
  if (plugin) {
    validateSinglePlugin(plugin);
  }
});

function validateSinglePlugin(plugin) {
  console.log(`\nValidating plugin: '${plugin}'\n`);
  if (
    validateSinglePluginData(plugin) &&
    validateSinglePluginPathes(plugin)
  ) {
    //valid
  } else {
    abort(
      `\nError: Framework: '${plugin}' Validation failed. \
      \nPlease check documentation in project repo and add missed items.`
    );
  }
}

function validateSinglePluginData(plugin) {
  const { name = null, version = null } = config = readPluginConfig(plugin);

  if (config.name && config.version && config.applicaster) {
    console.log(
      `Plugin: '${plugin}' - All keys fetched correctly from 'package.json'`
    );
    return true;
  } else {
    console.log(
      `Plugin: '${plugin}': - 'package.json' does not contains all the required params`
    );
    return false;
  }
}

function validateSinglePluginPathes(plugin) {
  const { name = null, version = null, isPlugin = false } = config = readPluginConfig(plugin);
  const baseFolderPath = `./plugins/${plugin}`
  console.log(
    `Validating required pathes for: ${plugin}'`
  );
  if (
    fs.existsSync(`${baseFolderPath}/Templates/.jazzy.yaml.ejs`) &&
    fs.existsSync(`${baseFolderPath}/.jazzy.yaml`) &&
    fs.existsSync(`${baseFolderPath}/Files`) &&
    validateSupportedPlatforms(plugin)
  ) {

    if (config.isPlugin == true && fs.existsSync(`${baseFolderPath}/Templates/manifest.config.js`)) {
      const failureText = `plugin validation failure: '${plugin}': manifest template is not defined`;
      console.log(failureText);
      return true;
    }
    else {
      return true;
    }
  }
  return false;
}

console.log("\nAll Plugins are valid!!!\n");
