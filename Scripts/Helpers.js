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
  return readJsonFile(`./plugins/${plugin}/Files/package.json`)
}

function readJsonFile(filePath) {
  const data = fs.readFileSync(`${filePath}`, "utf8");
  const parsedData = JSON.parse(data);
  return parsedData;
}

function readAppleFrameworkName(plugin) {
  var baseFolder = `./plugins/${plugin}/Files/apple`
  var path = require('path');
  var EXTENSION = '.podspec';
  var podspecFile= fs.readdirSync(`${baseFolder}`).filter(function(x) {
    return path.extname(x).toLowerCase() === EXTENSION;
  });

  var appleFrameworkName;
  if (podspecFile != null) {
    appleFrameworkName = path.basename(`${baseFolder+podspecFile}`, EXTENSION);
  }
  return appleFrameworkName
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
  readJsonFile,
  readAppleFrameworkName,
  proccessArgs,
  abort,
  circleBranch,
  compareVersion,
  isMasterBranch,
  gitTagDate,
  runInSequence,
  runInParallel
};
