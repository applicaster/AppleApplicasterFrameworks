#!/usr/bin/env node
const renderFileSync = require("cli-task-runner/utils/render");
require("dotenv").config();
const fs = require("fs");

const renderFile = require("cli-task-runner/utils/render");
require("dotenv").config();

function updateTemplate(ejsData, templatePath, outputPath) {
  renderFileSync(templatePath, outputPath, ejsData);
}

module.exports = { updateTemplate };
