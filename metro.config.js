const { resolve } = require("path");
const { readdirSync } = require("fs");
const R = require("ramda");

const packages = readdirSync("./plugins");
const resolveLocalPackages = packageName =>
  resolve(__dirname, `./plugins/${packageName}`);

const config = {
  resolver: {
    extraNodeModules: {
      "react-native": resolve(__dirname, "./node_modules/react-native")
    }
  },
  watchFolders: R.compose(
    R.append(resolve(__dirname)),
    R.map(resolveLocalPackages)
  )(packages)
};

module.exports = config;
