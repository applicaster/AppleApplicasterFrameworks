#!/usr/bin/env node

const { readFrameworkDataPlist } = require("./Helpers.js");
const { validateSingleFramework } = require("./validateHelper");

const frameworksList = readFrameworkDataPlist();

frameworksList.forEach(model => {
  const { framework } = model;
  if (framework) {
    validateSingleFramework(framework);
  }
});

console.log("\nAll Frameworks are valid!!!");
