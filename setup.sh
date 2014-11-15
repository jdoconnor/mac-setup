#!/bin/bash

set -e

# CLI Apps
cli_apps=(
  link libtool
  mysql
  node
  sqlite
  httpie
  gh
  rbenv
  git
)

# Apps
apps=(
  alfred
  dropbox
  google-chrome
  sublime-text
  sequel-pro
  google-chrome
  sourcetree
  google-drive
  caffeine
  iterm2
  ngrok
  shuttle
  virtualbox
  vagrant
  launchrocket
  spotify
  dash
  licecap
  slate
)

# fonts
fonts=(
  font-source-code-pro
  font-source-han-pro
  font-source-serif-pro
  font-source-sans-pro
)

# Specify the location of the apps
appdir="/Applications"

# Check for Homebrew
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

main() {

  # Ensure homebrew is installed
  homebrew

  # install command line apps
  echo "installing CLI apps..."
  brew install ${cli_apps[@]}

  # Install homebrew-cask
  echo "installing cask..."
  brew tap phinze/homebrew-cask
  brew install brew-cask

  # Tap alternative versions
  brew tap caskroom/versions

  # Tap the fonts
  brew tap caskroom/fonts

  # install apps
  echo "installing apps..."
  brew cask install --appdir=$appdir ${apps[@]}

  # install fonts
  echo "installing fonts..."
  brew cask install ${fonts[@]}

  # link with alfred
  alfred
  cleanup

  prezto
}

homebrew() {
  if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

alfred() {
  brew cask alfred link
}

cleanup() {
  brew cleanup
}

prezto() {
  zsh
  cd ~
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
  chsh -s /bin/zsh
}

main "$@"
exit 0
