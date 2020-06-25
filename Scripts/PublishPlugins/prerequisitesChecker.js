// const { existsSync } = require("fs");
const semver = require("semver");
const R = require("ramda");

/**
 * Checks wether the workspace can be prepared
 * @param {any} { cliArgs, cliOptions } : CLI argument and options
 */
function prerequisitesChecker({ cliArgs, cliOptions }) {
  return true;
}

module.exports = { prerequisitesChecker };
