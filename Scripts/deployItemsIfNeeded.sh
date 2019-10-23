#!/bin/sh
set -e

product_name=${1}
project_version="`/usr/libexec/PlistBuddy -c \"Print :CFBundleShortVersionString\" \"./${product_name}/Info.plist\"`"
echo $project_version

# # check if tag for this version is exists
# if [ $(git tag -l "$project_version") ]; then
#   echo "ERROR: Project version needs to be updated in order to create closed version, tag for this version already exists."
#   exit 1
# fi

# git tag $project_version
# git push origin $project_version

echo "Step 1: "

frameworksData=$(/usr/libexec/PlistBuddy ./PodsVersions.plist -c print | grep = | tr -d ' ')
pod repo add ApplicasterSpecs https://github.com/applicaster/CocoaPods.git || true

for PLIST_ITEMS in $frameworksData; do

	frameworkName=$(echo $PLIST_ITEMS | cut -d= -f1)
	frameworkVersion=$(echo $PLIST_ITEMS | cut -d= -f2)

	echo $frameworkName
	echo $frameworkVersion
	FILE="$HOME/.cocoapods/repos/ApplicasterSpecs/Specs/${frameworkName}/${frameworkVersion}/${frameworkName}.podspec"

	if [ -f "$FILE" ]; then
		echo "$FILE exist"
		# Skip it
	else
		echo "$FILE does not exist"
		# load the template podspec and replace the version and source link
		podspec_template=$(<"./${frameworkName}.podspec")
		podspec_template="${podspec_template//0.0.1-Dev/${frameworkVersion}}"
		podspec_filled="${podspec_template//__TAG__/${project_version}}"

		echo $podspec_template
		podspec_file_name="${frameworkName}.podspec"
		echo "${podspec_filled}" >"./${podspec_file_name}"
	fi
done

pod cache clean --all
pod repo push --verbose --no-private --allow-warnings --skip-import-validation --no-overwrite ApplicasterSpecs "${podspec_file_name}"
