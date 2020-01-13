#!/usr/bin/env node

const { readFrameworkDataPlist } = require("./Helpers.js");
const { validateSingleFramework } = require("./validateHelper");

const frameworksList = readFrameworkDataPlist();
const keys = Object.keys(frameworksList);

keys.forEach(framework => {
  if (framework) {
    validateSingleFramework(framework);
  }
});

console.log("\nAll Frameworks are valid!!!");
