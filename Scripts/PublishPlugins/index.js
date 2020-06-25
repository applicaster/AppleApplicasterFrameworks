const { taskRunner } = require("zapplicaster-cli/command/taskRunner");

const { prerequisitesChecker } = require("./prerequisitesChecker");

const { configurator } = require("./configurator");
const { npmPublish } = require("./npmPublish");
const { unitTestBuild, buildDocumentationJazzy } = require("../iosTasks");
const { zappifestPublish } = require("./zappifestPublish");
const { commitToGit } = require("./commitToGit");

const publishPluginTask = {
  name: "Publish plugin",
  startMessage: "Publishing plugin",
  prerequisitesChecker: prerequisitesChecker,
  configurator,
  steps: [
    {
      start: "Start Unit Tests for plugin",
      run: unitTestBuild,
      error: "Could not start Unit test task",
      completion: "Unit Test finished",
    },
    {
        start: "Bui",
        run: buildDocumentationJazzy,
        error: "Could not start Unit test task",
        completion: "Unit Test finished",
      },
  ],
};

module.exports = { publishPlugin: taskRunner(publishPluginTask) };
