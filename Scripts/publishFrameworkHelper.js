#!/usr/bin/env node

const renderFile = require("cli-task-runner/utils/render");
require("dotenv").config();

async function updateTemplate(ejsData, templatePath, outputPath) {
  console.log({ ejsData, templatePath, outputPath });
  return await renderFile(templatePath, outputPath, ejsData);
}

function manifestPath({ model, platform, template }) {
  const { plugin = null, framework = null } = model;
  iosPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/ios.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/ios.json`;
  iosQBPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/ios_for_quickbrick.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/ios_for_quickbrick.json`;
  tvosPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/tvos.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/tvos.json`;
  tvosQBPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/tvos_for_quickbrick.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/tvos_for_quickbrick.json`;
  androidPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/android.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/android.json`;
  androidQBPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/android_for_quickbrick.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/android_for_quickbrick.json`;
  if (
    plugin == true &&
    (platform == "ios" || platform == "ios_for_quickbrick" ||
    platform == "tvos" || platform == "tvos_for_quickbrick" ||
    platform == "android" || platform == "android_for_quickbrick") &&
    template != null
  ) {
    if (platform == "ios") {
      return iosPath;
    } else if (platform == "ios_for_quickbrick") {
      return iosQBPath;
    } else if (platform == "tvos") {
      return tvosPath;
    } else if (platform == "tvos_for_quickbrick") {
      return tvosQBPath;
    } else if (platform == "android") {
      return androidPath;
    } else if (platform == "android_for_quickbrick") {
      return androidQBPath;
    }
  } else {
    return null;
  }
}

module.exports = { updateTemplate, manifestPath };
