#!/usr/bin/env node

function updateParams(params, string) {
  const { version = null,
          appleFrameworkName = null,
          identifier = null
        } = params;

  if (params.version) {
      string = string.replace("##version##", params.version)
  }
  if (params.appleFrameworkName) {
      string = string.replace("##appleFrameworkName##", params.appleFrameworkName)
  }
  if (params.identifier) {
      string = string.replace("##identifier##", params.identifier)
  }

  return string
}


module.exports = {
  updateParams
};
