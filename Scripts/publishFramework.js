#!/usr/bin/env node

const fs = require("fs");
const shell = require("cli-task-runner/utils/shell");

const {
  compareVersion,
  readFrameworkDataPlist,
  isMasterBranch,
  automationVersionsDataJSON,
  updateAutomationVersionsDataJSON,
  gitTagDate
} = require("./Helpers");

const { updateTemplate, manifestPath } = require("./publishFrameworkHelper");
run();
async function run() {
  if (isMasterBranch() == false) {
    console.log("Step was skipped, 'master' branch required");
    process.exit(0);
  }

  const frameworksList = readFrameworkDataPlist();
  const frameworksAutomationList = automationVersionsDataJSON();

  let itemsToUpdate = [];
  let newAutomationObject = {};

  frameworksList.forEach(model => {
    const { framework = null, version_id = null } = model;
    const automationFrameworkVersion = frameworksAutomationList[framework];
    if (
      !automationFrameworkVersion ||
      compareVersion(version_id, automationFrameworkVersion)
    ) {
      console.log(`Adding framework to update list: ${framework}`);
      itemsToUpdate.push(model);
    }
    newAutomationObject[framework] = version_id;
  });

  if (itemsToUpdate.length > 0) {
    const newGitTag = gitTagDate();
    console.log({ itemsToUpdate });
    await updateRelevantTemplates(itemsToUpdate, newGitTag);
    await generateDocumentation(itemsToUpdate);
    await updateFrameworksVersionsInGeneralDocs(itemsToUpdate);
    await updateAutomationVersionsDataJSON(newAutomationObject);
    await commitChangesPushAndTag(itemsToUpdate, newGitTag);
    await uploadManifestsToZapp(itemsToUpdate);
  }
  console.log("System update has been finished!");
}

async function updateRelevantTemplates(itemsToUpdate, newGitTag) {
  const promises = itemsToUpdate.map(async model => {
    console.log({ model });

    const {
      framework = null,
      version_id = null,
      folder_path = null,
      is_plugin = null
    } = model;

    const ejsData = { version_id, new_tag: newGitTag };
    const templatesBasePath = `${folder_path}/Templates`;
    const projectBasePath = `${folder_path}/Project`;
    const templateExtension = ".ejs";

    await updateTemplate(
      ejsData,
      `${templatesBasePath}/.jazzy.yaml${templateExtension}`,
      `${projectBasePath}/.jazzy.yaml`
    );
    await updateTemplate(
      ejsData,
      `${templatesBasePath}/${framework}.podspec${templateExtension}`,
      `${framework}.podspec`
    );
    if (is_plugin) {
      const iosManifestPath = manifestPath({
        model,
        platform: "ios",
        template: false
      });
      const iosTemplatePath = manifestPath({
        model,
        platform: "ios",
        template: true
      });
      const tvosManifestPath = manifestPath({
        model,
        platform: "tvos",
        template: false
      });
      const tvosTemplatePath = manifestPath({
        model,
        platform: "tvos",
        template: true
      });
      if (
        iosManifestPath &&
        iosTemplatePath &&
        fs.existsSync(iosManifestPath)
      ) {
        await updateTemplate(ejsData, iosTemplatePath, iosManifestPath);
      }
      if (
        tvosManifestPath &&
        tvosTemplatePath &&
        fs.existsSync(tvosManifestPath)
      ) {
        await updateTemplate(ejsData, tvosTemplatePath, tvosManifestPath);
      }
    }
  });
  return await Promise.all(promises);
}

async function generateDocumentation(itemsToUpdate) {
  console.log("Generating documentation\n");
  const promises = itemsToUpdate.map(async model => {
    const { framework = null, folder_path = null } = model;
    console.log(`\nGeneration documentation for framework:${framework}`);
    const isPodfileExist = fs.existsSync(`${folder_path}/Project/Podfile`);
    if (isPodfileExist) {
      await shell.exec(`cd ${folder_path}/Project && bundle exec pod install`);
    }
    // Generate documentation
    await shell.exec(`cd ${folder_path}/Project && bundle exec jazzy`);
  });
  return await Promise.all(promises);
}

async function uploadManifestsToZapp(itemsToUpdate) {
  console.log("Uploading manifests to zapp");
  const promises = itemsToUpdate.map(async model => {
    const { is_plugin = null } = model;
    const zappToken = process.env["ZappToken"];
    if (is_plugin && zappToken) {
      const iosManifestPath = manifestPath({
        model,
        platform: "ios",
        template: false
      });
      const tvosManifestPath = manifestPath({
        model,
        platform: "tvos",
        template: false
      });
      if (iosManifestPath && fs.existsSync(iosManifestPath)) {
        await shell.exec(
          `zappifest publish --manifest ${iosManifestPath} --access-token ${zappToken}`
        );
      }
      if (tvosManifestPath && fs.existsSync(tvosManifestPath)) {
        await shell.exec(
          `zappifest publish --manifest ${tvosManifestPath} --access-token ${zappToken}`
        );
      }
    }
  });
  return await Promise.all(promises);
}

async function updateFrameworksVersionsInGeneralDocs(itemsToUpdate) {
  let ejsData = {};

  const promises = itemsToUpdate.map(async model => {
    const { framework = null, version_id = null } = model;
    ejsData[framework] = version_id;
  });
  await updateTemplate(ejsData, "README.md.ejs", `README.md`);
  return await Promise.all(promises);
}

async function commitChangesPushAndTag(itemsToUpdate, newGitTag) {
  await shell.exec("git add docs");
  await shell.exec("git add Frameworks");
  await shell.exec("git add README.md");
  await shell.exec("git add .versions_automation.json");
  let commitMessage = `System update, expected tag:${newGitTag}, frameworks:`;
  const promises = itemsToUpdate.map(async model => {
    const { framework = null, version_id = null, folder_path = null } = model;
    await shell.exec(`git add ${framework}.podspec`);
    await shell.exec(`git add ${folder_path}`);
    commitMessage += `, [${framework}:${version_id}]`;
  });

  console.log(`Message to commit: ${commitMessage}`);
  await shell.exec(`git commit -m "${commitMessage}"`);
  await shell.exec("git push origin master");
  await shell.exec(`git tag ${newGitTag}`);
  await shell.exec(`git push origin ${newGitTag}`);
  return await Promise.all(promises);
}
