const logger = require("@applicaster/zapplicaster-cli/src/logger");
const { abort } = require("./helpers.js");

async function prepareBiuldEnvironment({ pluginPath, iosModuleName }) {
  if (iosModuleName && pluginPath) {
    try {
      logger.log(`\nPreparing framework:${iosModuleName}\n`);
      const iosPluginPath = `${pluginPath}/apple`;
      const isPodfileExist = fs.existsSync(`${iosPluginPath}/Podfile`);
      const isPackageJsonExist = fs.existsSync(`${pluginPath}/package.json`);
      if (isPodfileExist) {
        if (isPackageJsonExist) {
          await shell.exec(`cd ${pluginPath} && npm install`);
        }
        await shell.exec(`cd ${iosPluginPath} && bundle exec pod install`);
        return true;
      } else {
        logger.log(`\Podfile not exist for framework:${iosModuleName}\n`);

        return false;
      }
    } catch (e) {
      abort(e.message);
    }
  } else {
    return false;
  }
}

export async function unitTestBuild({ iosModuleName, pluginPath }) {
  if (iosModuleName && pluginPath) {
    try {
      const readyToBuild = await prepareBiuldEnvironment();
      if (readyToBuild) {
        await shell.exec(`cd ${iosPluginPath} && set -o pipefail && xcodebuild \
            -workspace ./FrameworksApp.xcworkspace \
            -scheme ${iosModuleName} \
            -destination 'platform=iOS Simulator,OS=13.5,name=iPhone 11' \
            clean build test | tee xcodebuild.log | xcpretty --report html --output report.html`);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      abort(e.message);
    }
  } else {
    logger.log(`Can not start plugin unit test for path:$ ${pluginPath} \n`);
    return false;
  }
}

export async function buildDocumentationJazzy({ iosModuleName, pluginPath }) {
  if (
    iosModuleName &&
    pluginPath &&
    fs.existsSync(`${pluginPath}/apple/.jazzy.json`)
  ) {
    try {
      const readyToBuild = await prepareBiuldEnvironment();
      if (readyToBuild) {
        await shell.exec(
          `cd ${pluginPath}/apple && bundle exec jazzy --config .jazzy.json`
        );

        return true;
      } else {
        return false;
      }
    } catch (e) {
      abort(e.message);
    }
  } else {
    logger.log(`Podspec not exist for path:$ ${pluginPath} \n`);
    return false;
  }
}
