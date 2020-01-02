#!/usr/bin/env node

const fs = require("fs");
const { execSync } = require("child_process");

const {
  compareVersion,
  readFrameworkDataPlist,
  isMasterBranch,
  automationVersionsDataJSON,
  updateAutomationVersionsDataJSON,
  gitTagDate
} = require("./Helpers");

const { updateTemplate, manifestPath } = require("./publishFrameworkHelper");

// if (isMasterBranch() == false) {
//   console.log("Step wwas skipped, 'master' branch required");
//   process.exit(0);
// }

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
  updateRelevantTemplates(itemsToUpdate, newGitTag);
  generateDocumentation(itemsToUpdate);
  uploadManifestsToZapp(itemsToUpdate);
  // updateFrameworksVersionsInGeneralDocs(itemsToUpdate)
  commitChangesPushAndTag(itemsToUpdate, newGitTag);
}
updateAutomationVersionsDataJSON(newAutomationObject);
console.log("System update has been finished!");

function updateRelevantTemplates(itemsToUpdate, newGitTag) {
  itemsToUpdate.forEach(model => {
    const {
      framework = null,
      version_id = null,
      folder_path = null,
      is_plugin = null
    } = model;
    const ejsData = { version_id, new_tag: newGitTag };
    const templatesBasePath = `${folder_path}/Templates/`;
    const projectBasePath = `${folder_path}/Project/`;
    const templateExtension = ".ejs";

    updateTemplate(
      ejsData,
      `${templatesBasePath}/jazzy.yaml${templateExtension}`,
      `${projectBasePath}/.jazzy.yaml`
    );
    updateTemplate(
      ejsData,
      `${templatesBasePath}/${framework}.podspec${templateExtension}`,
      `${framework}.podspec`
    );
    if (is_plugin) {
      iosManifestPath = manifestPath({
        model,
        platform: "ios",
        template: false
      });
      iosTemplatePath = manifestPath({
        model,
        platform: "ios",
        template: true
      });
      tvosManifestPath = manifestPath({
        model,
        platform: "tvos",
        template: false
      });
      tvosTemplatePath = manifestPath({
        model,
        platform: "tvos",
        template: true
      });
      if (
        iosManifestPath &&
        iosManifestPath &&
        fs.existsSync(iosManifestPath)
      ) {
        updateTemplate(ejsData, iosTemplatePath, iosManifestPath);
      }
      if (
        tvosManifestPath &&
        tvosTemplatePath &&
        fs.existsSync(tvosManifestPath)
      ) {
        updateTemplate(ejsData, tvosTemplatePath, tvosManifestPath);
      }
    }
  });
}

function generateDocumentation(itemsToUpdate) {
  console.log("Generating documentation\n");
  itemsToUpdate.forEach(model => {
    const { framework = null, folder_path = null } = model;
    console.log(`\nGeneration documentation for framework:${framework}`);
    const isPodfileExist = fs.existsSync(`${folder_path}/Project/Podfile`);
    if (isPodfileExist) {
      execSync(`cd ${folder_path}/Project && bundle exec pod install`);
    }
    // Generate documentation
    execSync(`cd ${folder_path}/Project && jazzy`);
  });
}

function uploadManifestsToZapp(itemsToUpdate) {
  console.log("Uploading manifests to zapp");
  itemsToUpdate.forEach(model => {
    const { is_plugin = null } = model;
    const zappToken = process.env["ZappToken"];
    if (is_plugin && zappToken) {
      iosManifestPath = manifestPath({
        model,
        platform: "ios",
        template: false
      });
      tvosManifestPath = manifestPath({
        model,
        platform: "tvos",
        template: false
      });
      if (iosManifestPath && fs.existsSync(iosManifestPath)) {
        execSync(
          `zappifest publish --manifest ${ios_manifest_path} --access-token ${zappToken}`
        );
      }
      if (tvosManifestPath && fs.existsSync(tvosManifestPath)) {
        execSync(
          `zappifest publish --manifest ${tvos_manifest_path} --access-token ${zappToken}`
        );
      }
    }
  });
}

function commitChangesPushAndTag(itemsToUpdate, newGitTag) {
  execSync("git add docs");
  execSync("git add Frameworks");
  let commitMessage = `System update, expected tag:${new_git_tag}, frameworks:`;
  itemsToUpdate.forEach(model => {
    const { framework = null, version_id = null } = model;
    sh("git add #{framework}.podspec");
    commit_message += ` <${framework}:${version}>`;
  });
  console.log(`Message to commit: ${commit_message}`);
  execSync(`git commit -m ${commit_message}`);
  execSync("git push origin master");
  execSync(`git tag ${new_git_tag}`);
  execSync(`git push origin ${new_git_tag}`);
}
