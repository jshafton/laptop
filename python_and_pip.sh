#! /usr/bin/env bash

set -eo pipefail

GLOBAL_PYTHON_2_VERSION=2.7.18
GLOBAL_PYTHON_3_VERSION=3.10.1

echo "Installing Python and dependencies..."

if (command -v pyenv 1>/dev/null 2>&1); then
  echo "pyenv already installed"
else
  brew install pyenv
fi

if (command -v pyenv-virtualenv-init > /dev/null); then
  echo "pyenv-virtualenv already installed"
else
  brew install pyenv-virtualenv
fi

echo "Installing dependencies for python..."
brew list openssl@1.1 >/dev/null || brew install openssl@1.1
brew list openssl@3 >/dev/null || brew install openssl@3

echo "Initializing pyenv..."
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

echo "Installing global python versions..."
pyenv install "$GLOBAL_PYTHON_2_VERSION" --skip-existing
pyenv install "$GLOBAL_PYTHON_3_VERSION" --skip-existing
pyenv global "$GLOBAL_PYTHON_2_VERSION" "$GLOBAL_PYTHON_3_VERSION"

echo "Installing local python version for laptop install..."
pyenv install --skip-existing

echo "Setting python version to global 3.x version..."
export PYENV_VERSION="$GLOBAL_PYTHON_3_VERSION"

echo "Upgrading pip..."
PYENV_VERSION="$GLOBAL_PYTHON_2_VERSION" pip install --upgrade pip
pip3 install --upgrade pip

echo "Installing global pip packages..."
pip3 show awscli >/dev/null    || pip3 install awscli
pip3 show boto >/dev/null      || pip3 install boto
pip3 show yamllint >/dev/null  || pip3 install yamllint
pip3 show vim-vint >/dev/null  || pip3 install vim-vint
pip3 show ranger-fm >/dev/null || pip3 install ranger-fm

echo "Installing dependencies for pgcli..."
brew list libpq >/dev/null || brew install libpq

libpq_path=$(brew --prefix libpq)
openssl_path=$(brew --prefix openssl)

# Special fun required for libpq
PATH="$libpq_path/bin:$PATH" \
  LDFLAGS="-L$libpq_path/lib \
  -L$openssl_path/lib" \
  CPPFLAGS="-I$libpq_path/include \
  -I$openssl_path/include" \
  pip3 install pgcli

echo "Installing python support for Neovim..."
PYENV_VERSION="$GLOBAL_PYTHON_2_VERSION" pip install pynvim
pip3 install pynvim

echo "Installing pipenv and running package install..."
if (command -v pipenv 1>/dev/null 2>&1); then
  echo "pipenv already installed"
else
  brew install pipenv
  pipenv --python "$(cat .python-version)"
fi

# TODO: something weird with cryptography package
# brew install pkg-config libffi openssl
# env LDFLAGS="-L$(brew --prefix openssl)/lib" CFLAGS="-I$(brew --prefix openssl)/include" pip install cryptography
# env LDFLAGS="-L$(brew --prefix openssl)/lib" CFLAGS="-I$(brew --prefix openssl)/include" pipenv install cryptography

pipenv install
