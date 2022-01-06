#! /bin/bash

set -eo pipefail

GLOBAL_PYTHON_2_VERSION=2.7.16
GLOBAL_PYTHON_3_VERSION=3.8.8

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

echo "Initializing pyenv..."
eval "$(pyenv init -)"

original_pyenv="$PYENV_VERSION"
original_virtualenv="$VIRTUAL_ENV"

if [ -n "$original_virtualenv" ]; then
  deactivate || true
fi

echo "Installing global python versions..."
pyenv install "$GLOBAL_PYTHON_2_VERSION" --skip-existing
pyenv install "$GLOBAL_PYTHON_3_VERSION" --skip-existing
pyenv global "$GLOBAL_PYTHON_2_VERSION" "$GLOBAL_PYTHON_3_VERSION"

echo "Installing local python version for laptop install..."
pyenv install --skip-existing

echo "Setting python version to global 2.7 version..."
export PYENV_VERSION="$GLOBAL_PYTHON_2_VERSION"

echo "Upgrading pip..."
pip install --upgrade pip

echo "Installing global 2.7 pip packages..."
pip show awscli >/dev/null   || pip install awscli
pip show boto >/dev/null     || pip install boto
pip show yamllint >/dev/null || pip install yamllint
pip show vim-vint >/dev/null || pip install vim-vint

echo "Installing dependencies for pgcli..."
brew list libpq >/dev/null   || brew install libpq
brew list openssl >/dev/null || brew install openssl

libpq_path=$(brew --prefix libpq)
openssl_path=$(brew --prefix openssl)

echo "Installing global 3.8 python packages..."
export PYENV_VERSION="$GLOBAL_PYTHON_3_VERSION"
PATH="$libpq_path/bin:$PATH" LDFLAGS="-L$libpq_path/lib -L$openssl_path/lib" CPPFLAGS="-I$libpq_path/include -I$openssl_path/include" \
  pip3 install pgcli pynvim ranger-fm

echo "Installing python support for Neovim..."
pyenv virtualenv --force "$GLOBAL_PYTHON_2_VERSION" neovim2
pyenv virtualenv --force "$GLOBAL_PYTHON_3_VERSION" neovim3

pyenv activate neovim2
pip install neovim

pyenv activate neovim3
pip install neovim

echo "Resetting python version and virtualenv to local version..."
export PYENV_VERSION=$original_pyenv
if [ -n "$original_virtualenv" ]; then
  source "$original_virtualenv/bin/activate"
fi

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
