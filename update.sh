#! /usr/bin/env bash

notify() {
  echo "$(date +%H:%M:%S) - $1"
}

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Installing xcode command-line tools..."
if ( xcode-select -p &> /dev/null ); then
  echo "xcode command-line tools already installed."
else
  xcode-select --install
  until ( xcode-select -p &> /dev/null ); do
    echo "Waiting on xcode installation..."
    sleep 2
  done
fi

notify "Installing homebrew packages"
source "${BASH_SOURCE%/*}/setup/homebrew_packages.sh"

notify "Installing Python and pip packages"
source "${BASH_SOURCE%/*}/setup/python_and_pip.sh"

notify "Installing nodejs and npm packages"
source "${BASH_SOURCE%/*}/setup/nodejs_and_npm.sh"

notify "Installing Ruby and gems"
source "${BASH_SOURCE%/*}/setup/ruby_and_gems.sh"

notify "Configuring macOS defaults"
source "${BASH_SOURCE%/*}/setup/macos_defaults_sudo.sh"
source "${BASH_SOURCE%/*}/setup/macos_defaults_user.sh"

notify "Installing Mac App Store apps"
source "${BASH_SOURCE%/*}/setup/mac_app_store.sh"

notify "Installing software updates"
source "${BASH_SOURCE%/*}/setup/software_updates.sh"
