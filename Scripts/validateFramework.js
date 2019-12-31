#!/usr/bin/env node

const { validateSingleFramework } = require("./ValidateExistingFrameworks.js");

const args = proccessArgs();
if (args.length == 0) {
  abort("Error: expected argument Framework was not passed");
}
const frameworkToCheck = args[0];
validateSingleFramework(frameworkToCheck);
