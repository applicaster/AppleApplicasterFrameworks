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

const { updateTemplate } = require("./publishFrameworkHelper");

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
    console.log("Adding framework to update list: #{model}");
    itemsToUpdate.push(model);
  }
  newAutomationObject[framework] = version_id;
});

console.log(`Items to Update: ${itemsToUpdate}`);

if (itemsToUpdate.length > 0) {
  const newGitTag = gitTagDate();
  // updateRelevantTemplates(itemsToUpdate, newGitTag);
  generateDocumentation(itemsToUpdate);
  // uploadManifestsToZapp(itemsToUpdate)
  // updateFrameworksVersions(itemsToUpdate)
  // commitChangesPushAndTag(itemsToUpdate, newGitTag)
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
      iosFileName = "ios.json";
      tvosFileName = "tvos.json";
      iosManifestPath = `${folder_path}/Manifest/${iosFileName}`;
      tvosManifestPath = `${folder_path}/Manifest/${tvosFileName}`;
      if (fs.existsSync(iosManifestPath)) {
        updateTemplate(
          ejsData,
          `${templatesBasePath}/${iosFileName}${templateExtension}`,
          iosManifestPath
        );
      }
      if (fs.existsSync(tvosManifestPath)) {
        updateTemplate(
          ejsData,
          `${templatesBasePath}/${tvosFileName}${templateExtension}`,
          tvosManifestPath
        );
      }
    }
  });
}

function generateDocumentation(itemsToUpdate) {
  console.log("Generating documentation\n");
  itemsToUpdate.forEach(model => {
    const { framework = null, folder_path = null } = model;
    console.log(`\nGeneration documentation for framework:${framework}`);
    console.log(`${folder_path}/Project/Podfile`);
    console.log(fs.existsSync(`${folder_path}/Project/Podfile`));
    const isPodfileExist = fs.existsSync(`${folder_path}/Project/Podfile`);
    if (isPodfileExist) {
      console.log("I am in");
      execSync("ls");
      execSync(`cd ${folder_path}/Project && bundle exec pod install`);
      execSync("ls");
    }
    // Generate documentation
    execSync(`cd ${folder_path}/Project && jazzy`);
    // exec("cat *.js missing_file | wc -l", (error, stdout, stderr) => {
    //   if (error) {
    //     console.error(`exec error: ${error}`);
    //     return;
    //   }
    //   console.log(`stdout: ${stdout}`);
    //   console.error(`stderr: ${stderr}`);
    // });
  });
}
