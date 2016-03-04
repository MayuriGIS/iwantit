#!/bin/sh

# To run in your environment, the following (at a minimum) will need to be set:
# PROVISIONING_DIR
# OUTPUT_DIR : The script deletes this directory. Put something innocuous for this.

PROJECT_NAME="I Want It"
TOP="$( cd "$(dirname "${0}")" && pwd)"
APP_DIR="${TOP}"
WWW_DIR="${TOP}/lib/www"
PLIST="${APP_DIR}"/"${PROJECT_NAME}"/"${PROJECT_NAME}"-Info.plist
VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${PLIST}")
OUTPUT_DIR="${WORKSPACE}"/artifacts
XCARCHIVE="${OUTPUT_DIR}"/"${PROJECT_NAME}".xcarchive
SDK=iphoneos7.1
SIGNING_ID="iPhone Distribution: Oneview Commerce, Inc."
PROVISIONING_DIR="${HOME}/xcode_provisioning_profiles"
PROVISIONING="${PROVISIONING_DIR}"/In_House.mobileprovision
IPA_NAME="${OUTPUT_DIR}"/"${PROJECT_NAME}"_"${VERSION}"_"${1}".ipa
DOJO_VERSION="1.10.3"

function usage {
    echo "Usage: `basename $0` [-h] [<build number>]"
    echo "build number: Jenkins provided build number (required if -h is not specified)"
    echo "Options: -h Display this help"
    exit $1
}

function check_process {
    if [ "$?" != "0" ]; then
	echo $1
	git checkout -- "${PLIST}"
	exit $2
    fi
}

if [ "$1" == "-h" ]; then
    usage 0
fi

if [ $# -lt 1 ]; then
    usage 1
fi

echo $"\n################################################"
echo "Building version ${VERSION}, build number ${1}"
echo $"################################################\n"

# Change build number and app name
APP_NAME_WITH_VERSION="OVC | V${VERSION}"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${VERSION}.${1}" "${PLIST}"
/usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName ${APP_NAME_WITH_VERSION}" "${PLIST}"

# Remove old build artifacts if present.
rm -rf "${OUTPUT_DIR}"

# Create output director if it doesn't exist.
install -d "${OUTPUT_DIR}"

# Get the .mobileprovision with XCodes Unique Identifier from ~/Library/MobileDevice/Provisioning Profiles
# This is kind of hacky, and can break as soon as there is more than one provisioning profile in there...
UNIQUE_MOBILE_PROVISION_FILE=`ls "${HOME}/Library/MobileDevice/Provisioning Profiles" | head -1`
echo "the file ${UNIQUE_MOBILE_PROVISION_FILE}"
UNIQUE_MOBILE_PROVISION_ID="${UNIQUE_MOBILE_PROVISION_FILE%%.*}"
echo "the ident ${UNIQUE_MOBILE_PROVISION_ID}"

# Create the www zip
#cd "${WWW_DIR}"
#./package.sh "${DOJO_VERSION}"

# Build the App
cd "${APP_DIR}"
xcodebuild -scheme "${PROJECT_NAME}" -workspace "${PROJECT_NAME}.xcworkspace" -archivePath "${XCARCHIVE}" archive PROVISIONING_PROFILE="${UNIQUE_MOBILE_PROVISION_ID}" CODE_SIGN_IDENTITY="${SIGNING_ID}"

check_process "Cannot proceed with a failed build" 1


# Export IPA
xcrun -sdk iphoneos PackageApplication -v "${OUTPUT_DIR}/POSMClient.xcarchive/Products/Applications/POSMClient.app" -o "${IPA_NAME}"

check_process "Error creating .ipa file" 1

# Sign IPA
codesign -f -s "${SIGNING_ID}" "${IPA_NAME}"
codesign -v "${IPA_NAME}"

check_process "Could not sign .ipa" 1


# Zip the xcarchive dir (usefull for creating a Jenkins artifact)
zip -r "${OUTPUT_DIR}"/xcarchive.zip "${XCARCHIVE}"

#Uncomment to debug validation failures
#xcrun -sdk iphoneos Validation "${OUTPUT_DIR}/${PROJECT_NAME}.ipa"

# Modify the download.plist for this build
DOWNLOAD_SAMPLE_PLIST="${TOP}/download.sample.plist"
DOWNLOAD_PLIST="${OUTPUT_DIR}/download_${VERSION}_${1}.plist"
cp "${DOWNLOAD_SAMPLE_PLIST}" "${DOWNLOAD_PLIST}"
/usr/libexec/PlistBuddy -c "SET :items:0:metadata:bundle-version ${VERSION}" "${DOWNLOAD_PLIST}"
/usr/libexec/PlistBuddy -c "SET :items:0:metadata:title ${APP_NAME_WITH_VERSION}" "${DOWNLOAD_PLIST}"
/usr/libexec/PlistBuddy -c "SET :items:0:assets:0:url https://corebuild.local:8082/${JOB_NAME}/builds/${1}/archive/artifacts/POSMClient_${VERSION}_${1}.ipa" "${DOWNLOAD_PLIST}"

cd "${WORKSPACE}"
echo "<a href=\"itms-services://?action=download-manifest&url=https://corebuild.local:8082/${JOB_NAME}/builds/${BUILD_NUMBER}/archive/artifacts/download_${VERSION}_${BUILD_NUMBER}.plist\">Install</a>" > artifacts/download.html
cd "${TOP}"

git checkout -- "${PLIST}"


