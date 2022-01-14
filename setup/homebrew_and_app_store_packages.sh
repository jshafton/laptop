#! /usr/bin/env bash

set -eo pipefail

notify() {
  echo "$(date +%H:%M:%S) - $1"
}

if ( command -v brew &> /dev/null ); then
  notify "Homebrew already installed."
  brew update
else
  CI=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

  # Add brew bin to the path
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi;
fi

notify "==> Installing common homebrew packages"
brew bundle --file="${BASH_SOURCE%/*}/brewfile.common"

if [ "$INCLUDE_DEVOPS" == "1" ]; then
  notify "==> Installing devops homebrew packages"
  brew bundle --file="${BASH_SOURCE%/*}/brewfile.devops"
fi

if [ -f "${HOME}/.brewfile" ]; then
  notify "==> Installing personal homebrew packages"
  brew bundle --file="${HOME}/.brewfile"
fi

notify "==> Performing homebrew cleanup"
brew cleanup
