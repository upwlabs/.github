#!/bin/bash

set -e
set -o pipefail

usage() {
    echo "Usage: `basename $0` [ -c ] -m 'MODULE_NAME' -a 'APP_NAME'";
    exit 1;
}

RN_BUNDLE_DIR="rn"
RN_BUNDLE_META="${RN_BUNDLE_DIR}/meta.json"
RN_BUNDLE_TEMP="${RN_BUNDLE_DIR}/temp"
mkdir -p $RN_BUNDLE_TEMP


while getopts 'm:a:dc' OPT; do
    case $OPT in
        m)
            MODULE_NAME="$OPTARG";;
        a)
            APP_NAME="$OPTARG";;
        c)
            rm -rf "$RN_BUNDLE_TEMP"
            echo "Clear $RN_BUNDLE_TEMP"
            exit 0
            ;;
        *)
            usage;;
    esac
done

RN_ASSETS_OUTPUT_DIR="$MODULE_NAME/rn-drawable"
RN_BUNDLE_OUTPUT_DIR="$MODULE_NAME/src/main/assets/$APP_NAME"

echo ">>>>>>>>>>"
echo $RN_ASSETS_OUTPUT_DIR
echo $RN_BUNDLE_OUTPUT_DIR
echo "<<<<<<<<<<"

checksum=`cat "$RN_BUNDLE_META" | grep -Eo '"checksum": ?"(.[^"]+)"' | sed 's/"checksum":"//;s/"//'`
pathZip="$RN_BUNDLE_TEMP/$checksum.zip"
pathUnzip="$RN_BUNDLE_TEMP/$checksum"
MD5SUM="md5sum -b"
if [[ "$OSTYPE" == "darwin"* ]]; then
    MD5SUM="md5 -r"
fi
function downloadAndUnzip(){
  if [[ ! -f $pathZip ]]; then
    echo "download zip"
    download
  elif [[ $checksum != `$MD5SUM "$pathZip" | awk '{print $1}'` ]]; then
    echo `$MD5SUM "$pathZip"`
    echo "exiting zip broken, download again"
    download
  fi

  if [[ $checksum != `$MD5SUM "$pathZip" | awk '{print $1}'` ]]; then
      echo "downloaded zip checksum invalid, please check the bundle"
      exit 1
  fi

  rm -rf $pathUnzip
  mkdir -p $pathUnzip
  unzip -oq $pathZip -d $pathUnzip
}

function download() {
  url=`cat "$RN_BUNDLE_META" | grep -Eo '"download_url": ?"(.[^"]+)"' | sed 's/"download_url":"//;s/"//'`
  curl --output "$pathZip" "$url"
}

function copy() {
  echo "Removing old JS Bundle ..."
  rm -rf "$RN_ASSETS_OUTPUT_DIR"
  rm -f "$RN_BUNDLE_OUTPUT_DIR/main.jsbundle"
  rm -f "$RN_BUNDLE_OUTPUT_DIR/package.json"
  echo "Old JS Bundle removed"
  echo "----------"
  echo "Copying new JS Bundle ..."
  mkdir -p "$RN_BUNDLE_OUTPUT_DIR"
  cp "$pathUnzip/main.jsbundle" "$RN_BUNDLE_OUTPUT_DIR/main.jsbundle"
  cp "$pathUnzip/package.json" "$RN_BUNDLE_OUTPUT_DIR/package.json"
  mkdir -p "$RN_ASSETS_OUTPUT_DIR"
  cp -rf "$pathUnzip/"drawable* "$RN_ASSETS_OUTPUT_DIR"
  echo "New JS Bundle copied"
}

oldConfig="$RN_BUNDLE_OUTPUT_DIR/package.json"
if [[ ! -f "$oldConfig" ]]; then
  echo "Check: no bundle content"
  downloadAndUnzip
  copy
  exit 0
fi

newConfig="$pathUnzip/package.json"
if [[ ! -f "$newConfig" ]]; then
  echo "Check: no unzipped bundle content"
  downloadAndUnzip
fi

oldVersion=`cat "$oldConfig" | grep -Eo '"release": ?"(.[^"]+)"' | sed 's/"release":"//;s/"//'`
newVersion=`cat "$newConfig" | grep -Eo '"release": ?"(.[^"]+)"' | sed 's/"release":"//;s/"//'`

echo "old version: $oldVersion"
echo "new version: $newVersion"
echo "------------------------"
if [[ $newVersion != $oldVersion ]]; then
  copy
else
  echo "bundle is already up to date"
fi