#! /usr/bin/env bash

set -eo pipefail

# TODO: separate personal stuff into personal brewfile

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

notify "==> Installing basic homebrew packages"
brew bundle --file=-<<EOF
brew "ack"
brew "asdf"
brew "bash"
brew "bash-completion"
brew "bat"
brew "cmake"
brew "coreutils"
brew "ctags"
brew "curl"
brew "diffutils"
brew "direnv"
brew "dockutil"
brew "elinks"
brew "fasd"
brew "fd"
brew "fontconfig"
brew "freetype"
brew "git"
brew "git-delta"
brew "gnu-getopt"
brew "gnutls"
brew "go"
brew "grep"
brew "highlight"
brew "hping"
brew "htop-osx"
brew "httperf"
brew "httpry"
brew "hub"
brew "iftop"
brew "jq"
brew "json-c"
brew "lazygit"
brew "leiningen"
brew "less"
brew "mackup"
brew "mas"
brew "mercurial"
brew "moreutils"
brew "mtr"
brew "neovim"
brew "ngrep"
brew "nmap"
brew "pcre"
brew "pigz"
brew "psgrep"
brew "readline"
brew "rename"
brew "ripgrep"
brew "scrypt"
brew "shellcheck"
brew "svn"
brew "the_silver_searcher"
brew "tig"
brew "tmux"
brew "tree"
brew "vim"
brew "watch"
brew "wget"
EOF

notify "==> Installing homebrew cask packages"
brew bundle --file=-<<EOF
# main dev apps
cask "iterm2"
cask "vimr"
cask "authy"
cask "docker"
cask "datagrip"
cask "firefox"
cask "google-chrome"
cask "dash"
cask "postman"
cask "slack"

# quicklook plugins
cask "syntax-highlight"
cask "qlstephen"
cask "qlvideo"

# personal apps
cask "marta"
cask "dropbox"
cask "vlc"
cask "nvalt"
cask "caffeine"
cask "telegram"
cask "signal"
cask "calibre"
cask "android-messages"
cask "remember-the-milk"
cask "kindle"
cask "send-to-kindle"
cask "xbar"
cask "transmission"
cask "plex-media-server"
cask "notion"
cask "bitwarden"
cask "yt-music"
cask "google-drive"
cask "skitch"

# logitech drivers for mouse/keyboard
tap "homebrew/cask-drivers"
cask "homebrew/cask-drivers/logitech-options"

# paid apps
cask "bartender"
cask "daisydisk"
cask "istat-menus"
cask "alfred"

# bidness stuff
cask "microsoft-outlook"
cask "microsoft-excel"
cask "zoom"
EOF

notify "==> Installing homebrew fonts"
brew bundle --file=-<<EOF
tap "homebrew/cask-fonts"
cask "font-source-code-pro"
cask "font-source-code-pro-for-powerline"
cask "font-anonymice-powerline"
cask "font-droid-sans-mono-for-powerline"
cask "font-inconsolata-for-powerline"
cask "font-meslo-for-powerline"
cask "font-ubuntu-mono-derivative-powerline"
cask "font-meslo-lg-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-hack-nerd-font"
cask "font-victor-mono-nerd-font"
EOF

notify "==> Installing homebrew completions"
brew bundle --file=-<<EOF
brew "bundler-completion"
brew "gem-completion"
brew "pip-completion"
brew "rake-completion"
brew "ruby-completion"
brew "tmuxinator-completion"
EOF
