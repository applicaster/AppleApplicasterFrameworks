#!/usr/bin/env node

const fs = require("fs");
const semver = require("semver");
const moment = require("moment");
const { readdirSync, statSync } = require('fs')
const { join } = require('path')

const dirs = p => readdirSync(p).filter(f => statSync(join(p, f)).isDirectory())

function readPluginsList() {
  const path = './plugins/';
  return dirs(path)
}

function readPluginConfig(plugin) {
  const package = fs.readFileSync(`./plugins/${plugin}/Files/package.json`, "utf8");
  const parsedData = JSON.parse(package);
  return parsedData;
}

function supportsApple(plugin) {
  const pluginConfig = readPluginConfig(plugin)
  return (pluginConfig.applicaster.supportedPlatforms.indexOf(searchStr) > -1)
}

function readAppleFrameworkName(plugin) {
  fs.readdir(dirpath, function(err, files) {
    const podspec = files.filter(el => /\.podspec$/.test(el))
    console.log(podspec);
  })
}

function updateVersion(string, version) {
  return string.replace("##version##", version)
}

function proccessArgs() {
  return process.argv.slice(2);
}

function abort(message) {
  console.log(message);
  process.exit(1);
}

function circleBranch() {
  const { CIRCLE_BRANCH } = process.env;
  return CIRCLE_BRANCH;
}

function isMasterBranch() {
  return circleBranch() == "master";
}

function compareVersion(ver1, ver2) {
  return semver.gt(ver1, ver2);
}

function automationVersionsDataJSON() {
  const json = fs.readFileSync(".versions_automation.json", "utf8");
  try {
    return JSON.parse(json);
  } catch (e) {
    return {};
  }
}

async function updateAutomationVersionsDataJSON(data) {
  const json = JSON.stringify(data);
  fs.writeFileSync(".versions_automation.json", json, {
    encoding: "utf8"
  });
  return true;
}

function gitTagDate() {
  return moment().format("Y.M.D.H-M-S");
}

async function runInSequence(items, asyncFunc) {
  return items.reduce(async (previous, current) => {
    await previous;
    return asyncFunc(current);
  }, Promise.resolve());
}

async function runInParallel(commands) {
  const promises = commands.map(command => command());
  const result = await Promise.all(promises);
  return result;
}

module.exports = {
  readPluginConfig,
  readPluginsList,
  supportsApple,
  readAppleFrameworkName,
  updateVersion
  proccessArgs,
  abort,
  circleBranch,
  compareVersion,
  isMasterBranch,
  automationVersionsDataJSON,
  updateAutomationVersionsDataJSON,
  gitTagDate,
  runInSequence,
  runInParallel
};
