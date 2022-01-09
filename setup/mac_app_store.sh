#! /usr/bin/env bash

set -eo pipefail

# TODO: separate personal stuff into personal file

notify() {
  echo "$(date +%H:%M:%S) - $1"
}

install_mas_app() {
  local app_code="$1"
  local app_name="$2"

  if ( mas list | grep -Fq "$app_code" ); then
    notify "$app_name already installed."
  else
    notify "Installing $app_name"
    mas install "$app_code"
  fi
}

notify "==> Installing app store apps"
install_mas_app 497799835  "xcode"
install_mas_app 986304488  "Kiwi for Gmail"
install_mas_app 449830122  "HyperDock"
install_mas_app 1303222628 "Paprika Recipe Manager"
install_mas_app 1352778147 "Bitwarden"

notify "==> Upgrading app store apps"
mas upgrade
