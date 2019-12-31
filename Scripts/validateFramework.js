#!/usr/bin/env node
const { validateSingleFramework } = require("./validateHelper");
const { proccessArgs } = require("./Helpers");

const args = proccessArgs();
if (args.length == 0) {
  abort("Error: expected argument Framework was not passed");
}
const frameworkToCheck = args[0];
validateSingleFramework(frameworkToCheck);
