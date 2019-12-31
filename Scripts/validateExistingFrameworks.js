#!/usr/bin/env node
require("dotenv").config();
const renderFile = require("cli-task-runner/utils/render");

async function generateHtml(appInfo) {
  const template = `Scripts/Templates/ZappFirebaseAnalytics.podspec.ejs`;
  const original = `Scripts/Templates/ZappFirebaseAnalytics.podspec`;

  await renderFile(template, original, appInfo);
}

const appInfo = { new_tag: "24.12.2020", version_id: "1.2.0" };

async function runCmd() {
  try {
    await generateHtml(appInfo);
  } catch (e) {
    console.log(e);
    process.exit(1);
  }
}
runCmd();
