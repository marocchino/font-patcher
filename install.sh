#!/bin/bash

set -exo pipefail

if [ "$1" = "" ]; then
    echo "Usage: $0 <target_dir> [arch]"
    echo "  target_dir: path to the game directory"
    echo "  arch: x64 | unix | x86 default: unix"
    exit 1
fi


TARGET_DIR=$1
# x64 | unix | x86
ARCH=${2:-unix}
# https://github.com/BepInEx/BepInEx/tags
BEPINEX_VERSION=5.4.21
BEPINEX_FULL_VERSION=5.4.21.0
# https://github.com/bbepis/XUnity.AutoTranslator/tags
AUTO_TRANSLATOR_VERSION=5.2.0

echo =========== install
cd "$TARGET_DIR"
wget "https://github.com/BepInEx/BepInEx/releases/download/v${BEPINEX_VERSION}/BepInEx_${ARCH}_${BEPINEX_FULL_VERSION}.zip"
wget "https://github.com/bbepis/XUnity.AutoTranslator/releases/download/v${AUTO_TRANSLATOR_VERSION}/XUnity.AutoTranslator-BepInEx-${AUTO_TRANSLATOR_VERSION}.zip"
unzip "BepInEx_${ARCH}_${BEPINEX_FULL_VERSION}.zip"
unzip "XUnity.AutoTranslator-BepInEx-${AUTO_TRANSLATOR_VERSION}.zip"
mkdir -p "$TARGET_DIR/BepInEx/config"
cp AutoTranslatorConfig.ini "$TARGET_DIR/BepInEx/config/AutoTranslatorConfig.ini"
APP_NAME=$(find "$TARGET_DIR" -name '*.app' -type d -print -quit)

if [ "$APP_NAME" = "" ]; then
  cp "ridibatang sdf" "$TARGET_DIR/."
else
  cp "ridibatang sdf" "$APP_NAME/."
fi


echo =========== cleanup
rm "BepInEx_${ARCH}_${BEPINEX_FULL_VERSION}.zip"
rm "XUnity.AutoTranslator-BepInEx-${AUTO_TRANSLATOR_VERSION}.zip"
cd -
