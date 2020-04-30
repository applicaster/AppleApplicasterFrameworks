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
  tvosPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/tvos.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/tvos.json`;
  androidPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/android.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/android.json`;
  if (
    plugin == true &&
    (platform == "ios" || platform == "tvos" || platform == "android") &&
    template != null
  ) {
    if (platform == "ios") {
      return iosPath;
    } else if (platform == "tvos") {
      return tvosPath;
    } else if (platform == "android") {
      return androidPath;
    }
  } else {
    return null;
  }
}

module.exports = { updateTemplate, manifestPath };
