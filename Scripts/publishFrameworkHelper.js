#!/usr/bin/env node
const renderFileSync = require("cli-task-runner/utils/render");
require("dotenv").config();
const fs = require("fs");

const renderFile = require("cli-task-runner/utils/render");
require("dotenv").config();

async function updateTemplate(ejsData, templatePath, outputPath) {
  console.log({ ejsData, templatePath, outputPath });
  return await renderFile(templatePath, outputPath, ejsData);
}

function manifestPath({ model, platform, template }) {
  const { folder_path = null, plugin = null } = model;

  iosPath = template == true ? "Templates/ios.json.ejs" : "Manifest/ios.json";
  tvosPath =
    template == true ? "Templates/tvos.json.ejs" : "Manifest/tvos.json";
  if (
    plugin == true &&
    (platform == "ios" || platform == "tvos") &&
    template != null &&
    folder_path != null
  ) {
    if (platform == "ios") {
      return `${folder_path}/${iosPath}`;
    } else if (platform == "tvos") {
      return `${folder_path}/${tvosPath}`;
    }
  } else {
    return null;
  }
}

module.exports = { updateTemplate, manifestPath };
