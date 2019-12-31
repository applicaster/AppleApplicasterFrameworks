#!/usr/bin/env node

const renderFile = require("cli-task-runner/utils/render");
require("dotenv").config();

function updateTemplate(ejsData, templatePath, outputPath) {
  renderFileSync(templatePath, outputPath, ejsData);
}

module.exports = { updateTemplate };
