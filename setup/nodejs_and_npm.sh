#! /usr/bin/env bash

set -eo pipefail

GLOBAL_NODEJS_VERSION=16.13.1

if [ -f "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh" ]; then
  . "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"
fi

notify() {
  echo "$(date +%H:%M:%S) - $1"
}

install_asdf_plugin() {
  if asdf plugin list | grep -Fq "$1" >/dev/null; then
    notify "asdf plugin $1 already installed"
  else
    asdf plugin add "$1"
  fi
}

install_npm_global_package() {
  notify "Installing package $1"

  if npm -g list "$1" >/dev/null; then
    notify "npm package $1 already installed"
  else
    npm -g install "$1"
  fi
}

if ! brew list asdf >/dev/null; then
  notify "! ERROR: asdf version manager not installed"
  exit 1
fi

notify "==> Installing nodejs plugin"
install_asdf_plugin nodejs

notify "==> Installing global python versions"
asdf install nodejs "$GLOBAL_NODEJS_VERSION"
asdf global nodejs "$GLOBAL_NODEJS_VERSION"

notify "==> Installing global npm packages..."
install_npm_global_package yarn
install_npm_global_package coffeescript
install_npm_global_package jshint
install_npm_global_package eslint
install_npm_global_package coffeelint
install_npm_global_package jsonlint
install_npm_global_package neovim
install_npm_global_package bash-language-server

notify "==> Updating nodejs shims"
asdf reshim nodejs
