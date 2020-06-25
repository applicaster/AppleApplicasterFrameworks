#!/usr/bin/env node
const { basename } = require("path");
// const {
//   writeJsonToFile,
//   readdirAsync,
//   readJsonFile,
// } = require("@applicaster/zapplicaster-cli/command/file");
const {
  writeJsonToFile,
  readdirAsync,
  readJsonFile,
} = require("@applicaster/zapplicaster-cli/src/file");

run();
async function run() {
  const files = await readdirAsync(
    "/Users/antonkononenko/Work3/AppleFrameworks/plugins/zapp_local_notifications/apple"
  );

  const searchedFile = "ZappLocalNotifications.podspec.json".endsWith(
    ".podspec.json"
  );
  const name = "ZappLocalNotifications.podspec.json".replace(
    ".podspec.json",
    ""
  );
  console.log({ searchedFile, files, name });
  // try {
  //   await getPodspecFile({
  //     appleFolder:
  //       "/Users/antonkononenko/Work3/AppleFrameworks/plugins/zapp_local_notifications/apple/",
  //   });
  // } catch (erro) {
  //   console.log({ error });
  // }
}
async function getPodspecFile({ appleFolder }) {
  const files = await readdirAsync(appleFolder);

  for (let i in files) {
    if (extname(files[i]) === ".podpsec.json") {
      return files[i];
    }
  }

  return null;
}
