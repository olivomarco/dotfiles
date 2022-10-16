#!/bin/bash

if [ "$(uname -s)" != "DARWIN" ] ; then
    echo "current machine is not mac."
    exit 1
fi

# main
echo "doing setup for whole Mac - press CTRL+C in 5 seconds to abort..."
sleep 5

sudo_enabled=$(sudo -v)
if [ ! -z $sudo_enabled ] ; then
  echo "manually make sure to add this line to /etc/sudoers file and re-launch this program:"
  echo "${USER} ALL=(ALL) NOPASSWD: ALL"
  exit 1
fi

echo "update existing software"
sudo softwareupdate -i -a

echo "installing homebrew..."
sudo /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "installing global packages..."
brew install zsh
brew install ImageMagick
brew install ffmpeg
brew install perl
brew install sqlite3
brew install wget
brew install gzip
brew install lynx
brew install mysql-client
brew install unrar
brew install w3m
brew install iterm2
brew install htop
brew install mas
brew install transmission
brew install python3
brew install kubectx
brew install watch
brew install sops
brew install gnupg
brew install speedtest-cli
brew install tree
brew install bitwarden-cli
brew install bat
brew install telnet
brew install md5sha1sum

echo "installing more global software via cask/mas..."
brew tap caskroom/cask
brew install caskroom/cask/brew-cask
brew cask install firefox
brew cask install google-chrome
brew cask install authy
brew cask install caffeine
brew cask install dbeaver-community
brew cask install dropbox
brew cask install handbrake
brew cask install iterm2
brew cask install microsoft-word
brew cask install microsoft-excel
brew cask install microsoft-powerpoint
brew cask install onedrive
brew cask install onyx
brew cask install openoffice
mas install microsoft-remote-desktop-10
brew cask install skype
brew cask install slack
mas install stuffit-expander-16
brew cask install tunnelblick
brew cask install veracrypt
brew cask install visual-studio-code
brew cask install vlc
mas install whatsize
brew cask install virtualbox
brew cask install krita
mas install imovie
brew cask install pixlr
brew cask install wireshark
mas install 1352778147 # bitwarden
mas install 1274495053 # microsoft-todo
brew install --cask darktable
brew install --cask homebrew/cask-drivers/gutenprint
brew install --cask logitech-camera-settings
brew install --cask adobe-acrobat-reader

echo "installing docker on mac..."
brew install docker docker-machine
brew cask install virtualbox
docker-machine create --driver virtualbox default

echo "adding zsh to /etc/shells..."
echo /usr/local/bin/zsh | sudo tee -a /etc/shells

echo "set the Finder prefs for showing a few different volumes on the Desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

echo "put display to sleep if we're in the top-right hot corner"
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 0
echo "show mission control if we're in the bottom-left hot corner"
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0
echo "show desktop if we're in the bottom-right hot corner"
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

echo "done."
