#!/usr/bin/env node
// set -e
const fs = require("fs");
const {
  readPluginConfig,
  readAppleFrameworkName
} = require("./helpers.js");

function validateSupportedPlatforms(plugin) {
  const { applicaster = null } = config = readPluginConfig(plugin);
  const baseFolderPath = `./plugins/${plugin}`
  const supportedPlatforms = config.applicaster.supportedPlatforms

    var result = false
    if (supportsApple(supportedPlatforms)) {
        if (fs.existsSync(`${baseFolderPath}/Files/apple`) && readAppleFrameworkName(plugin)) {
          console.log(`--> plugin "${plugin}" supports Apple`);
          result = true
        }
    }

    if (supportsAndroid(supportedPlatforms)) {
      if (fs.existsSync(`${baseFolderPath}/Files/android`)) {
        console.log(`--> plugin "${plugin}" supports Android`);
        result = true
      }
    }
    return result
}

function supportsApple(supportedPlatforms) {
  const platforms = [
    "ios",
    "ios_for_quickbrick",
    "tvos",
    "tvos_for_quickbrick"
  ]
  return supportedPlatforms.some(r=> platforms.includes(r))
}

function supportsAndroid(supportedPlatforms) {
  const platforms = [
    "android",
    "android_for_quickbrick"
  ]
  return supportedPlatforms.some(r=> platforms.includes(r))
}

module.exports = {
  validateSupportedPlatforms
};
