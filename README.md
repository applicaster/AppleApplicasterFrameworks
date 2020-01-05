# Apple Frameworks

![CircleCI](https://circleci.com/gh/applicaster/AppleApplicasterFrameworks.svg?style=svg&circle-token=8fedcc78af0010cec307b550771857ed27eee835)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20|%20tvOS-f6b854.svg)
[![GitHub license](https://img.shields.io/github/license/applicaster/AppleApplicasterFrameworks)](https://github.com/applicaster/AppleApplicasterFrameworks/blob/master/LICENSE)

- **OS:** iOS 10+, tvOS 12+
- **Languages:** Swift 5.1, frameworks can be used in Swift and Objective-C
- **Tool requirements:** Xcode 11.3, Cocoapods 1.8.3
- **License:** [Appache 2.0](https://github.com/applicaster/AppleApplicasterFrameworks/blob/master/LICENSE)

## Table of contents

- [Overview](#overview)
- [Folder Structure](#folder_structure)
- [Usage](#usage)
- [How to add new framework?](#how_to_add_new_framework)
- [How to update existing framework?](#how_to_update_framework)

## Overview

This respository is a main container for general frameworks and plugins for [ZappApple](https://github.com/applicaster/AppleApplicasterFrameworks) project. Each frameworks defined here support `cocoapods` as dependency manager.

## Folder Structure
Repository has predefined structure if you want to add something, please use strictly structure

```swift
Apple Framworks
├── docs // Contains generated documentation for the frameworks. Content are generates automatically.
├── fastlane // Configuration of the fastlane] deployment tool used in CI.
├── Frameworks // Frameworks data seperated by folders.
│   └── *FrameworkName // All Frameworks, not part of ZAPP PLUGINS type.
│       ├── Files // Files that relevant for the framework.
│       ├── Project // Xcode Project created to generate documentation.
│       │   ├── .jazzy.yaml // Jazzy configuration file that defined to create auto generated docs
│       │   └── * // Files relevant to project
│       └── Templates // Template files relevant for framework automation.
│       │   ├── .jazzy.yaml.ejs // Jazzy template configuration file that defined to create auto generated docs.
│       │   └── FrameworkName.podpec.ejs  // Cocoapods template dependency.
│   └── PluginType // Type of the plugin, please check availible plugin list below
│       ├── *FrameworkName // All Frameworks, not part of ZAPP PLUGINS type.
│       │   ├── Files // Files that relevant for the framework.
│       │   ├── Manifest // ZAPP PLUGINS manifests describes plugin.
│       │   ├── Project // Xcode Project created to generate documentation.
│       │   │   ├── .jazzy.yaml // Jazzy configuration file that defined to create auto generated docs
│       │   │   └── * // Files relevant to project
│       │   ├── Templates // Template files relevant for framework automation.
│       │   │   ├── .ios.json.ejs // Template manifest for ios ZAPP PLUGIN structure.
│       │   │   ├── .tvos.json.ejs // Template manifest for tvos ZAPP PLUGIN structure.
│       │   │   ├── .jazzy.yaml.ejs // Jazzy template configuration file that defined to create auto generated docs.
├── FrameworksApp // General client app that has defined all availible frameworks.
├── Scripts // Automotization scripts. All scripts defined in JavaScript.
├── .versions_automation.json // Automation file, must not be changed by user. Contains JSON with title and version of each framework.
├── frameworksData.plist // Contains information about frameworks: title, version and etc.
├── Gemfile // Ruby packages.
├── LICENSE // Repo licence type.
├── package.json // Java Script packages.
├── README.md // Git docs file.
└── *.podspec // Cocoapods dependency files for all frameworks.
```

## How to add new framework

## How to update existing framework

## Frameworks List

[ZappCore](https://applicaster.github.io/AppleApplicasterFrameworks/ZappCore/index.html)

#### Plugins

##### Analytics

[**Google Analytics: 1.9.0**](https://applicaster.github.io/AppleApplicasterFrameworks/ZappGoogleAnalytics/index.html)
- **Documentation**
- **Zapp Manifests:**
	- [ios](https://zapp.applicaster.com/admin/plugin_versions?id=zapp_google_analytics&platform=ios)
	- [tvos](https://zapp.applicaster.com/admin/plugin_versions?id=zapp_google_analytics&platform=tvos)


[Firebase](https://applicaster.github.io/AppleApplicasterFrameworks/ZappFirebaseAnalytics/index.html)

##### Crashlogs

[MS App Center](https://applicaster.github.io/AppleApplicasterFrameworks/ZappCrashlogsMsAppCenter/index.html)

##### Player Dependant

[Google Interactive Media Ads](https://applicaster.github.io/AppleApplicasterFrameworks/ZappGoogleInteractiveMediaAds/index.html)
