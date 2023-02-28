#!/bin/bash

set -exo pipefail

if [ "$1" = "" ]; then
  echo "Usage: $0 <target_dir> [arch]"
  echo "  target_dir: path to the game directory"
  echo "  arch: x64 | unix | x86 default: unix"
  exit 1
fi

# set variables
TARGET_DIR=$1
# x64 | unix | x86
ARCH=${2:-unix}
# https://github.com/BepInEx/BepInEx/tags
BEPINEX_VERSION=5.4.21
BEPINEX_FULL_VERSION=5.4.21.0
# https://github.com/bbepis/XUnity.AutoTranslator/tags
AUTO_TRANSLATOR_VERSION=5.2.0
# found osx app
APP_NAME=$(find "$TARGET_DIR" -name '*.app' -type d -print -quit)
APP_NAME=$(basename "$APP_NAME")

# copy files
mkdir -p "$TARGET_DIR/BepInEx/config"
cp AutoTranslatorConfig.ini "$TARGET_DIR/BepInEx/config/AutoTranslatorConfig.ini"

if [ "$APP_NAME" = "" ]; then
  cp "ridibatang sdf" "$TARGET_DIR/."
else
  cp "ridibatang sdf" "$TARGET_DIR/$APP_NAME/."
fi

# download and extract
cd "$TARGET_DIR"
if [ ! -f "BepInEx_${ARCH}_${BEPINEX_FULL_VERSION}.zip" ]; then
  wget "https://github.com/BepInEx/BepInEx/releases/download/v${BEPINEX_VERSION}/BepInEx_${ARCH}_${BEPINEX_FULL_VERSION}.zip"
fi
if [ ! -f "XUnity.AutoTranslator-BepInEx-${AUTO_TRANSLATOR_VERSION}.zip" ]; then
  wget "https://github.com/bbepis/XUnity.AutoTranslator/releases/download/v${AUTO_TRANSLATOR_VERSION}/XUnity.AutoTranslator-BepInEx-${AUTO_TRANSLATOR_VERSION}.zip"
fi
unzip "BepInEx_${ARCH}_${BEPINEX_FULL_VERSION}.zip"
unzip "XUnity.AutoTranslator-BepInEx-${AUTO_TRANSLATOR_VERSION}.zip"
echo "Cleaning up"
rm "BepInEx_${ARCH}_${BEPINEX_FULL_VERSION}.zip"
rm "XUnity.AutoTranslator-BepInEx-${AUTO_TRANSLATOR_VERSION}.zip"

# edit run_bepinex.sh
if [ "$ARCH" = "unix" ]; then
  BEPINEX_SH="$TARGET_DIR/run_bepinex.sh"

  # found x86_64 app
  if [ "$APP_NAME" = "" ]; then
    APP_NAME=$(find "$TARGET_DIR" -name '*.x86_64' -type f -print -quit)
  fi
  if [ "$APP_NAME" = "" ]; then
    echo "Could not find executable_name"
    exit 1
  fi

  echo "APP_NAME: $APP_NAME"
  if grep -q "$APP_NAME" "$BEPINEX_SH"; then
    echo "Skipping executable_name changes, already replaced"
  else
    sed "/executable_name=\"\".*/ s/\"\"/\"$APP_NAME\"/" "$BEPINEX_SH" > "$BEPINEX_SH.tmp"
    mv "$BEPINEX_SH.tmp" "$BEPINEX_SH"
  fi
  chmod +x "$BEPINEX_SH"
  "$BEPINEX_SH"
fi
exit 0
