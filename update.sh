#! /usr/bin/env bash

notify() {
  echo "$(date +%H:%M:%S) - $1"
}

# Ask for the administrator password upfront
sudo -v -p "Enter sudo password for configuration"

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [[ "$(uname)" == "Darwin" ]]; then

  notify "============================"
  notify "=== Installing Rosetta 2 ==="
  notify "============================"
  softwareupdate --install-rosetta --agree-to-license

  notify "==========================================="
  notify "=== Installing xcode command-line tools ==="
  notify "==========================================="
  if ( xcode-select -p &> /dev/null ); then
    echo "xcode command-line tools already installed."
  else
    xcode-select --install
    until ( xcode-select -p &> /dev/null ); do
      echo "Waiting on xcode installation..."
      sleep 2
    done
  fi

  notify "===================================="
  notify "=== Installing homebrew packages ==="
  notify "===================================="
  source "${BASH_SOURCE%/*}/setup/homebrew_and_app_store_packages.sh"

fi

notify "=========================================="
notify "=== Installing Python and pip packages ==="
notify "=========================================="
source "${BASH_SOURCE%/*}/setup/python_and_pip.sh"

notify "=========================================="
notify "=== Installing nodejs and npm packages ==="
notify "=========================================="
source "${BASH_SOURCE%/*}/setup/nodejs_and_npm.sh"

notify "================================ "
notify "=== Installing Ruby and gems === "
notify "================================ "
source "${BASH_SOURCE%/*}/setup/ruby_and_gems.sh"

if [[ "$(uname)" == "Darwin" ]]; then

  notify "==================================="
  notify "=== Installing software updates ==="
  notify "==================================="
  source "${BASH_SOURCE%/*}/setup/software_updates.sh"

fi

if [ "$INCLUDE_DEVOPS" == "1" ]; then

  notify "========================================"
  notify "=== Installing other DevOps software ==="
  notify "========================================"
  source "${BASH_SOURCE%/*}/setup/other_devops_software.sh"

fi

notify "==> DONE! <=="
