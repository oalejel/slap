#!/bin/sh

set -e

is_executable () {
  command -v "$1" >/dev/null 2>&1
}

alias errcho='>&2 echo'
npm_needs_sudo=0 # true

echo "# Installing slap..."

if ! (is_executable npm && is_executable node); then
  if is_executable brew; then
    brew install node
    npm_needs_sudo=1 # false
  elif is_executable port; then
    port install nodejs
  elif is_executable apt-get; then
    wget -qO- https://deb.nodesource.com/setup | sudo bash - # Adds NodeSource repository to dpkg
    sudo apt-get install -y nodejs
  elif is_executable yum; then
    curl -sL https://rpm.nodesource.com/setup | bash - # Adds NodeSource repository to yum
    sudo yum install -y nodejs
  elif is_executable emerge; then
    emerge nodejs
  elif is_executable pacman; then
    pacman -S nodejs
  else
    errcho "Couldn't determine OS. Please install NodeJS manually, then run this script again."
    errcho "Visit https://github.com/joyent/node/wiki/installing-node.js-via-package-manager for instructions on how to install NodeJS on your OS."
    exit 1
  fi
fi

if (return $npm_needs_sudo); then
  sudo npm install -g slap
else
  npm install -g slap
fi