const R = require("ramda");
const { resolve } = require("path");
const semver = require("semver");
const git = require("simple-git/promise");
const {
  readdirAsync,
  readJsonFile,
} = require("@applicaster/zapplicaster-cli/src/file");

const logger = require("@applicaster/zapplicaster-cli/src/logger");

function resolvePluginPath(pluginPath) {
  let resolvedPluginPath;
  let pluginPackageJson;

  if (!pluginPath) {
    throw new Error(
      "You need to provide a plugin path. See command's help to check the syntax"
    );
  }

  resolvedPluginPath = resolve(process.cwd(), pluginPath);

  try {
    const pJsonPath = resolve(resolvedPluginPath, "package.json");
    pluginPackageJson = require(pJsonPath);
  } catch (e) {
    throw new Error(
      "Could not find the plugin package.json file. Make sure the path is correct"
    );
  }

  if (!pluginPackageJson.applicaster) {
    throw new Error(
      "your plugin's package.json is missing the applicaster property"
    );
  }

  if (!pluginPackageJson.applicaster.supportedPlatforms) {
    throw new Error(
      "your plugin's package.json doesn't have a list of supported platforms"
    );
  }

  if (!pluginPackageJson.applicaster.zappOwnerAccountId) {
    throw new Error("your plugin's package.json is missing zappOwnerAccountId");
  }

  return [resolvedPluginPath, pluginPackageJson];
}

async function configurator({ cliArgs, cliOptions }) {
  const pluginPath = R.head(cliArgs) || cliOptions.pluginPath;
  let resolvedPluginPath;
  let pluginPackageJson;

  [resolvedPluginPath, pluginPackageJson] = resolvePluginPath(pluginPath);
  let iosModuleName = await getIosModuleName();

  const { version } = cliOptions;

  if (!version || !semver.valid(version)) {
    throw new Error("you need to provide a valid semver version");
  }

  const zappOwnerAccountId = R.path(
    ["applicaster", "zappOwnerAccountId"],
    pluginPackageJson
  );

  logger.log(`Publishing plugin for ${platforms}`);

  const config = {
    pluginPath: resolvedPluginPath,
    pluginPackageJson,
    verbose,
    version,
    zappOwnerAccountId,
    iosModuleName,
  };

  return config;
}

async function getIosModuleName({ appleFolder }) {
  const filePodspec = await getPodspecFile({ appleFolder });
  if (filePodspec) {
    return filePodspec.replace(".podspec.json");
  }
  return null;
}

async function getPodspecFile({ appleFolder }) {
  const files = await readdirAsync(appleFolder);

  for (let i in files) {
    const currentPath = files[i];
    if (currentPath && currentPath.endsWith(".podpsec.json")) {
      return currentPath;
    }
  }

  return null;
}

module.exports = { configurator };
