#!/usr/bin/env node

const { readPluginsList } = require("./helpers.js");
const { validateSinglePlugin } = require("./validateHelper");

const pluginsList = readPluginsList();
pluginsList.forEach(plugin => {
  if (plugin) {
    validateSinglePlugin(plugin);
  }
});

console.log("\nAll Plugins are valid!!!\n");
