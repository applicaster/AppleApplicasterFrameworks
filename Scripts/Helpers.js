#!/usr/bin/env node

const fs = require("fs");
const plist = require("plist");

function readFrameworkDataPlist() {
  const plistData = fs.readFileSync("./FrameworksData.plist", "utf8");
  const parsedData = plist.parse(plistData);
  return parsedData;
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

module.exports = { readFrameworkDataPlist, proccessArgs, abort, circleBranch };
