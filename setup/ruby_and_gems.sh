#! /usr/bin/env bash

set -eo pipefail

GLOBAL_RUBY_VERSION=3.1.0

if [ -f "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh" ]; then
  . "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"
elif [ -f "${HOME}/.asdf/asdf.sh" ]; then
  . "${HOME}/.asdf/asdf.sh"
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

install_ruby_global_gem() {
  notify "Installing gem $1"

  if gem list | grep -Fq "$1" >/dev/null; then
    notify "ruby gem $1 already installed"
  else
    gem install "$1"
  fi
}

if ! hash asdf >/dev/null; then
  notify "! ERROR: asdf version manager not installed"
  exit 1
fi

notify "==> Installing ruby plugin"
install_asdf_plugin ruby

notify "==> Installing global ruby version"
asdf install ruby "$GLOBAL_RUBY_VERSION"
asdf global ruby "$GLOBAL_RUBY_VERSION"

notify "==> Installing global ruby gems"
install_ruby_global_gem bundler

notify "==> Configuring bundler"
bundle config --global jobs "$(nproc)"

notify "==> Updating ruby gem shims"
asdf reshim ruby
