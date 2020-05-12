#!/usr/bin/env node

function updateParams(params, string) {
  const { version = "##version##",
          appleFrameworkName = "##appleFrameworkName##",
          identifier = "##identifier##"
        } = placeholders;

  const { version = null,
          appleFrameworkName = null,
          identifier = null
        } = params;

  if (params.version) {
      string = string.replace(placeholders.version, params.version)
  }
  if (params.appleFrameworkName) {
      string = string.replace(placeholders.appleFrameworkName, params.appleFrameworkName)
  }
  if (params.identifier) {
      string = string.replace(placeholders.identifier, params.identifier)
  }

  return string
}


module.exports = {
  updateParams
};
