const { existsSync } = require("fs");

const { writeJsonToFile, readdirAsync, readJsonFile } = require("../../file");
const logger = require("@applicaster/zapplicaster-cli/src/logger");
var path = require("path");

require("dotenv").config();

async function iosUnitTests(configuration) {
    
}

module.exports = { generateAppleTemplates };
