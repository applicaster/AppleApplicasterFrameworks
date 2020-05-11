#!/usr/bin/env node
const exec = require('child_process').exec;
const fs = require("fs");

const {
  abort,
  readPluginConfig,
  runInSequence
} = require("./helpers.js");

const renderFile = require("cli-task-runner/utils/render");
require("dotenv").config();

async function updateTemplate(ejsData, templatePath, outputPath) {
  console.log({ ejsData, templatePath, outputPath });
  return await renderFile(templatePath, outputPath, ejsData);
}

function manifestPath({ model, platform, template }) {
  const { plugin = null, framework = null } = model;
  iosPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/ios.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/ios.json`;
  tvosPath =
    template == true
      ? `Frameworks/Plugins/${framework}/Templates/tvos.json.ejs`
      : `Frameworks/Plugins/${framework}/Templates/tvos.json`;
  if (
    plugin == true &&
    (platform == "ios" || platform == "tvos") &&
    template != null
  ) {
    if (platform == "ios") {
      return iosPath;
    } else if (platform == "tvos") {
      return tvosPath;
    }
  } else {
    return null;
  }
}

function os_func() {
    this.execCommand = function (cmd) {
        return new Promise((resolve, reject)=> {
           exec(cmd, (error, stdout, stderr) => {
             if (error) {
                reject(error);
                return;
            }
            resolve(stdout)
           });
       })
   }
}

function packageVersionsInfoFile(plugin) {
  var folder = `./.tempdata`
  return `${folder}/${plugin}.pd`
}
async function saveCurrentPackagesVersion(pluginsList) {
  console.log("Saving current npm packages versions\n");
  var folder = `./.tempdata`
  if (!fs.existsSync(folder)){
    fs.mkdirSync(folder);
  }
  pluginsList.forEach(plugin => {
    if (plugin) {
      const { name = null, version = null } = config = readPluginConfig(plugin);
      if (config.name) {
        var os = new os_func();
        os.execCommand(`npm view ${config.name} versions --json`).then(response => {
            var name = config.name
            fs.writeFile(`${packageVersionsInfoFile(plugin)}`, `${response}`, function (err) {
              if (err) throw err;
            });
        }).catch(error => {
            console.log("os >>>", error);
        })
      }
    }
  });
}

module.exports = {
  updateTemplate,
  manifestPath,
  saveCurrentPackagesVersion,
  packageVersionsInfoFile
};
