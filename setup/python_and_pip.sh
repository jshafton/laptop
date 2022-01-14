#! /usr/bin/env bash

set -eo pipefail

GLOBAL_PYTHON_2_VERSION=2.7.18
GLOBAL_PYTHON_3_VERSION=3.10.1
GLOBAL_AWSCLI_VERSION=2.4.9

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

install_brew_package() {
  notify "Installing package $1"

  if brew list "$1" >/dev/null; then
    notify "brew package $1 already installed"
  else
    brew install "$1"
  fi
}

install_python2_pip() {
  notify "Installing package $1"

  if python2 -m pip show "$1" >/dev/null; then
    notify "pip2 package $1 already installed"
  else
    python2 -m pip install "$1"
  fi
}

install_python3_pip() {
  notify "Installing package $1"

  if pip3 show "$1" >/dev/null; then
    notify "pip3 package $1 already installed"
  else
    pip3 install "$1"
  fi
}

if ! brew list asdf >/dev/null; then
  notify "! ERROR: asdf version manager not installed"
  exit 1
fi

notify "==> Installing dependencies for python via homebrew"
install_brew_package openssl@1.1
install_brew_package openssl@3

notify "==> Installing Python plugin"
install_asdf_plugin python

notify "==> Installing global python versions"
asdf install python "$GLOBAL_PYTHON_2_VERSION"
asdf install python "$GLOBAL_PYTHON_3_VERSION"
asdf global python "$GLOBAL_PYTHON_3_VERSION" "$GLOBAL_PYTHON_2_VERSION"

notify "==> Upgrading pip"
python2 -m pip install --upgrade pip
python3 -m pip install --upgrade pip

notify "==> Installing dependencies for pgcli"
brew list libpq >/dev/null || brew install libpq

libpq_path=$(brew --prefix libpq)
openssl_path=$(brew --prefix openssl)

# Special fun required for libpq
PATH="$libpq_path/bin:$PATH" \
  LDFLAGS="-L$libpq_path/lib \
  -L$openssl_path/lib" \
  CPPFLAGS="-I$libpq_path/include \
  -I$openssl_path/include" \
  install_python3_pip pgcli

notify "==> Installing global versions of python packages"
# maybe plugins:
#
# delta
install_asdf_plugin awscli
asdf install awscli "$GLOBAL_AWSCLI_VERSION"
asdf global awscli "$GLOBAL_AWSCLI_VERSION"

notify "==> Updating python shims"
asdf reshim python
