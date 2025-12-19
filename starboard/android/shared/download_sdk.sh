#!/bin/sh
set -e

TOOLS_VERSION="6200805"
TOOLS_FILENAME="commandlinetools-linux-${TOOLS_VERSION}_latest.zip"
BASE_URL="https://dl.google.com/android/repository"

# Single source of truth
ANDROID_SDK_ROOT="${ANDROID_HOME:-$HOME/android-sdk}"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export ANDROID_SDK_ROOT="$ANDROID_SDK_ROOT"

SDK_MANAGER="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"

echo "ANDROID SDK ROOT: $ANDROID_SDK_ROOT"

if [ ! -f "$SDK_MANAGER" ]; then
  echo "Installing Android SDK command line tools..."

  rm -rf "$ANDROID_SDK_ROOT"
  mkdir -p "$ANDROID_SDK_ROOT/cmdline-tools"

  cd /tmp
  curl -sSLO "$BASE_URL/$TOOLS_FILENAME"
  unzip -q "$TOOLS_FILENAME"
  mv cmdline-tools "$ANDROID_SDK_ROOT/cmdline-tools/latest"
  rm "$TOOLS_FILENAME"

  echo "Command line tools installed"
fi

export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

yes | sdkmanager --licenses

sdkmanager \
  "platform-tools" \
  "platforms;android-31" \
  "platforms;android-34" \
  "build-tools;31.0.0" \
  "build-tools;34.0.0" \
  "cmake;3.22.1" \
  "ndk;25.2.9519653"

echo "Android SDK setup complete"
