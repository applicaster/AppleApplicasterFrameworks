#!/usr/bin/env node

const { readPluginsList } = require("./Helpers.js");
const { validateSinglePlugin } = require("./validateHelper");

const pluginsList = readPluginsList();
pluginsList.forEach(plugin => {
  if (plugin) {
    validateSinglePlugin(plugin);
  }
});

console.log("\nAll Frameworks are valid!!!\n");
