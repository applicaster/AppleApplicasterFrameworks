#!/usr/bin/env node

const fs = require("fs");
const shell = require("cli-task-runner/utils/shell");
const util = require("util");
const exec = util.promisify(require("child_process").exec);

const {
  readPluginsList,
  readPluginConfig,
  readJsonFile,
  abort,
  basePathForModel,
  runInSequence,
  compareVersion,
  readFrameworkDataPlist,
  isMasterBranch,
  automationVersionsDataJSON,
  updateAutomationVersionsDataJSON,
  gitTagDate,
} = require("./helpers.js");

const {
  updateTemplate,
  manifestPath,
  saveCurrentPackagesVersion,
  packageVersionsInfoFile,
} = require("./publishPluginsHelper");

run();
async function run() {
  // if (isMasterBranch() == false) {
  //   console.log("Step was skipped, 'master' branch required");
  //   process.exit(0);
  // }

  const pluginsList = readPluginsList();
  await saveCurrentPackagesVersion(pluginsList);

  pluginsList.forEach((plugin) => {
    if (plugin) {
      console.log(`readJsonFile filePath: ${packageVersionsInfoFile(plugin)}`);

      const { name = null, version = null } = (config = readPluginConfig(
        plugin
      ));
      const {} = (currentVersions = readJsonFile(
        packageVersionsInfoFile(plugin)
      ));
      if (config.name) {
        console.log(
          `config.name: ${config.name}, currentVersions: ${currentVersions}`
        );
      }
    }
  });

  //
  // let itemsToUpdate = [];
  // let newAutomationObject = {};
  //
  // const keys = Object.keys(frameworksList);
  //
  // keys.forEach(key => {
  //   const model = frameworksList[key];
  //   model["framework"] = key;
  //   const { framework = null, version_id = null } = model;
  //   const automationFrameworkVersion = frameworksAutomationList[framework];
  //   if (
  //     !automationFrameworkVersion ||
  //     compareVersion(version_id, automationFrameworkVersion)
  //   ) {
  //     console.log(`Adding framework to update list: ${framework}`);
  //     itemsToUpdate.push(model);
  //   }
  //   newAutomationObject[framework] = version_id;
  // });
  //
  // if (itemsToUpdate.length > 0) {
  //   const newGitTag = gitTagDate();
  //   console.log({ itemsToUpdate });
    await updateRelevantTemplates(itemsToUpdate, newGitTag);// Podspec, documenation, android
    await unitTestAndGenerateDocumentation(itemsToUpdate); //IOS, JS, Adnroid
    await updateFrameworksVersionsInGeneralDocs(frameworksList); //Updated docs 
    await updateAutomationVersionsDataJSON(newAutomationObject); // JSON automation
    await uploadNpmPackages(itemsToUpdate); // No need
    await uploadManifestsToZapp(itemsToUpdate); // No need
    await commitChangesPushAndTag(itemsToUpdate, newGitTag);
    // Workflow-1
    // If needed to be updated
    // Unit Test
    // Update template(native stuff) this can be moved to cli
    // All what relevant to docs 
    // CLI Plugin 
    // Push everything

    // Workflow-2 Nightly
    // Unit test (posibility to start every for all) + Documentaion


    await uploadFrameworksToCocoaPodsPublic(itemsToUpdate);
  // }
  // console.log("System update has been finished!");
}

async function updateRelevantTemplates(itemsToUpdate, newGitTag) {
  try {
    const promises = itemsToUpdate.map(async (model) => {
      const baseFolderPath = basePathForModel(model);

      const { framework = null, version_id = null, plugin = null } = model;

      const ejsData = { version_id, new_tag: newGitTag };
      const templatesBasePath = `${baseFolderPath}/manifests`;
      const templateExtension = ".ejs";

      await updateTemplate(
        ejsData,
        `${templatesBasePath}/.jazzy.yaml${templateExtension}`,
        `${baseFolderPath}/apple/.jazzy.yaml`
      );

      const podspecPath = plugin
        ? `${baseFolderPath}/apple/${framework}.podspec`
        : `${framework}.podspec`;

      await updateTemplate(
        ejsData,
        `${templatesBasePath}/${framework}.podspec${templateExtension}`,
        podspecPath
      );
    });
    return await Promise.all(promises);
  } catch (e) {
    abort(e.message);
  }
  return Promise.resolve();
}

async function uploadManifestsToZapp(itemsToUpdate) {
  console.log("Uploading manifests to Zapp");
  try {
    const promises = itemsToUpdate.map(async (model) => {
      const { framework = null, plugin = null } = model;

      const zappToken = process.env["ZAPP_TOKEN"];
      const zappAccount = process.env["ZAPP_ACCOUNT"];
      if (plugin && zappToken) {
        console.log(`Uploading manifests for: ${framework}`);

        const iosManifestPath = manifestPath({
          model,
          platform: "ios",
          template: false,
        });
        const tvosManifestPath = manifestPath({
          model,
          platform: "tvos",
          template: false,
        });

        if (iosManifestPath && fs.existsSync(iosManifestPath)) {
          await shell.exec(
            `zappifest publish --manifest ${iosManifestPath} --access-token ${zappToken} --account ${zappAccount}`
          );
        }
        if (tvosManifestPath && fs.existsSync(tvosManifestPath)) {
          await shell.exec(
            `zappifest publish --manifest ${tvosManifestPath} --access-token ${zappToken} --account ${zappAccount}`
          );
        }
      }
    });
    await Promise.all(promises);
  } catch (e) {
    abort(e.message);
  }
  return Promise.resolve();
}

async function unitTestAndGenerateDocumentation(itemsToUpdate) {
  console.log("Unit tests and generation documentation\n");
  try {
    const result = await runInSequence(itemsToUpdate, async (model) => {
      const { framework = null } = model;
      console.log(`\nPreparing framework:${framework}\n`);
      const baseFolderPath = basePathForModel(model);
      const isPodfileExist = fs.existsSync(`${baseFolderPath}/Podfile`);
      const isPackageJsonExist = fs.existsSync(
        `${baseFolderPath}/package.json`
      );
      if (isPodfileExist) {
        if (isPackageJsonExist) {
          await shell.exec(`cd ${baseFolderPath} && npm install`);
        }
        await shell.exec(`cd ${baseFolderPath} && bundle exec pod install`);
        await shell.exec(`cd ${baseFolderPath} && set -o pipefail && xcodebuild \
        -workspace ./FrameworksApp.xcworkspace \
        -scheme ${framework} \
        -destination 'platform=iOS Simulator,name=iPhone 11,OS=13.3' \
        clean build test | tee xcodebuild.log | xcpretty --report html --output report.html`);
        await shell.exec(`cd ${baseFolderPath} && bundle exec jazzy`);
      }
    });
    return result;
  } catch (e) {
    abort(e.message);
  }
}

async function uploadFrameworksToCocoaPodsPublic(itemsToUpdate) {
  console.log("Publishing to CocoaPods public repo\n");
  try {
    await shell.exec(
      `pod cache clean --all && pod repo add ApplicasterSpecs git@github.com:applicaster/CocoaPods.git || true`
    );
    const result = await runInSequence(itemsToUpdate, async (model) => {
      const { framework = null, plugin = null } = model;
      if (framework && !plugin) {
        console.log(`\nTrying to push CocoaPods framework:${framework}\n`);
        await shell.exec(
          `pod repo update || true && pod repo push --verbose --no-private --allow-warnings --use-libraries --skip-import-validation ApplicasterSpecs ./${framework}.podspec`
        );
      }
    });
    return result;
  } catch (e) {
    abort(e.message);
  }
}

async function updateFrameworksVersionsInGeneralDocs(itemsToUpdate) {
  try {
    let ejsData = {};

    const keys = Object.keys(itemsToUpdate);

    const promises = keys.map(async (framework) => {
      const model = itemsToUpdate[framework];

      const { version_id = null } = model;
      ejsData[framework] = version_id;
    });
    await updateTemplate(ejsData, "README.md.ejs", `README.md`);
    await Promise.all(promises);
  } catch (e) {
    abort(e.message);
  }
  return Promise.resolve();
}

async function commitChangesPushAndTag(itemsToUpdate, newGitTag) {
  try {
    await shell.exec("git add docs");
    await shell.exec("git add Frameworks");
    await shell.exec("git add README.md");
    await shell.exec("git add .versions_automation.json");
    let commitMessage = `System update, expected tag:${newGitTag}, frameworks:`;
    const promises = itemsToUpdate.map(async (model) => {
      const baseFolderPath = basePathForModel(model);

      const { framework = null, plugin = null } = model;
      if (!plugin) {
        await shell.exec(`git add ${framework}.podspec`);
      }

      await shell.exec(`git add ${baseFolderPath}`);
    });
    await Promise.all(promises);
    itemsToUpdate.forEach((model) => {
      const { framework = null, version_id = null } = model;
      commitMessage += ` [${framework}:${version_id}]`;
    });
    console.log(`Message to commit: ${commitMessage}`);
    await shell.exec(`git commit -m "${commitMessage}"`);
    await shell.exec("git push origin master");
    await shell.exec(`git tag ${newGitTag}`);
    await shell.exec(`git push origin ${newGitTag}`);
  } catch (e) {
    abort(e.message);
  }

  return Promise.resolve();
}

async function uploadNpmPackages(itemsToUpdate) {
  const promises = itemsToUpdate.map(async (model) => {
    const baseFolderPath = basePathForModel(model);

    const { version_id = null, plugin = null, framework = null } = model;
    if (plugin) {
      console.log(`Publishing plugin:${framework}, version:${version_id}`);
      try {
        await shell.exec(
          `cd ${baseFolderPath}/Files && yarn publish --new-version ${version_id} --no-git-tag-version`
        );
      } catch (e) {
        abort(e.message);
      }
    }
  });
  return await Promise.all(promises);
}
