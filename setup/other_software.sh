#! /usr/bin/env bash

set -eo pipefail

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
    asdf plugin add "$1" "${@:2}"
  fi
}
notify "==> Installing Terraform plugin"
install_asdf_plugin terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf install terraform 1.0.11
asdf global terraform 1.0.11
asdf reshim terraform
