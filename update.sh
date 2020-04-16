#! /bin/sh

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

echo "Installing Homebrew..."
if ( which brew &> /dev/null ); then
  echo "Homebrew already installed."
else
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "Installing Git..."
if ( which git &> /dev/null ); then
  echo "Git already installed."
else
  brew install git
fi

echo "Installing Python..."
if ( brew list --versions python &> /dev/null ); then
  echo "Python already installed."
else
  brew install python
fi

echo "Installing Ansible via pip..."
if ( which ansible  &> /dev/null ); then
  echo "Ansible already installed."
else
  pip install ansible==1.9.6
fi

echo "Running Ansible playbook..."
cd ansible
ansible-playbook -i inventory -c local local_install.yml --ask-sudo-pass "${@:1}"
