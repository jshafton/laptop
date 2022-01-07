#! /usr/bin/env bash

set -eo pipefail

notify() {
  echo "$(date +%H:%M:%S) - $1"
}

notify "==> Installing software updates"
softwareupdate --install --all 2>&1

notify "==> Re-accepting xcode terms"
sudo xcodebuild -license accept 2>&1
