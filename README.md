# Pre-installation

## Shell configuration

If `bash` isn't your default shell and you want it to be:

```
sudo chsh -s /bin/bash $(whoami)
```

You may need to log out / back in after this (or at least start a new terminal).

## Configure dotfiles

If you have any "dotfiles" to install, do it before you run this installer. See
the below sections for more specifics.

### Personal Homeberw packages

If you'd like to install your own configuration of Homebrew packages in
addition to the ones installed by this script, create a brew file in
`${HOME}/.brewfile` using the specification outlined
[here](https://github.com/Homebrew/homebrew-bundle).

### Default ruby gems

Any gems you'd like installed with any Ruby installation on your system can be
placed in `${HOME]}/.default-gems`, one gem per line.

### Default python packages

Any pip packages you'd like installed with any Python installation on your
system can be placed in `${HOME]}/.default-python-packages`, one package per
line.

### Default node.js packages

Any npm packages you'd like installed with any node.js installation on your
system can be placed in `${HOME]}/.default-npm-packages`, one package per line.

# Installation

Clone this repository with `git` and pick from the following install options:

## Default installation

`./update.sh`

## DevOps installation

This includes a bunch of DevOps utilities in addition to the default
installation.

`INCLUDE_DEVOPS=1 ./update.sh`

# Post-install configuration

After the install completes, you may need to manually add paths and other
configurations to your profile for bash/zsh (`~/.bash_profile`/`~/.zprofile`).

## utility functions

```sh
path_prepend() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}
```

## homebrew bins and ENV vars

**NOTE:** this exports `HOMEBREW_PREFIX` which is used by the subsequent code.

```sh
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
```

## homebrew completions

```sh
if type brew &>/dev/null
then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

```

## asdf (version manager) and its shims

```sh
if [ -f "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh" ]; then
  . "${HOMEBREW_PREFIX}/opt/asdf/libexec/asdf.sh"
fi
```

## add psql and other postgresql bins to the path

```sh
if [ -d "${HOMEBREW_PREFIX}/opt/libpq/bin" ]; then
  path_prepend "${HOMEBREW_PREFIX}/opt/libpq/bin"
fi;
```

## add coreutils to the path

```sh
if [ -d ${HOMEBREW_PREFIX}/opt/coreutils/libexec ]; then
  export GNU_COREUTILS_PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin"
  export GNU_COREUTILS_MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman"
fi;

if [ -d $GNU_COREUTILS_PATH ]; then
  path_prepend "$GNU_COREUTILS_PATH"
fi;

if [ -d $GNU_COREUTILS_MANPATH ]; then
  export MANPATH="$GNU_COREUTILS_MANPATH:$PATH"
fi;
```
