#!/bin/bash

if [ "$(uname -s | tr '[:upper:]' '[:lower:]')" != "darwin" ]; then
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
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo >> $HOME/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv zsh)"' >> $HOME/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

echo "installing global packages..."
brew install zsh
brew install handy
brew install ImageMagick
brew install ffmpeg
brew install perl
brew install sqlite3
brew install wget
brew install git-lfs
brew install gzip
brew install lynx
brew install mysql-client
brew install unrar
brew install w3m
brew install iterm2
brew install htop
brew install mas
#brew install transmission
brew install python3
brew install kubectx
brew install watch
brew install sops
brew install gnupg
brew install speedtest-cli
brew install tree
brew install jq
brew install bitwarden-cli
brew install bat
brew install telnet
brew install md5sha1sum
brew install jless

echo "installing more global software via cask/mas..."
brew install firefox
brew install google-chrome
mas install 937984704 # amphetamine app
brew install dbeaver-community
brew install dropbox
brew install handbrake
brew install microsoft-word
brew install microsoft-excel
brew install microsoft-powerpoint
#brew install onedrive
brew install glances
brew install onyx
brew install slack
#brew install tunnelblick
#brew install veracrypt
brew install visual-studio-code
brew install vlc
mas install imovie
#brew install wireshark
#brew install --cask powershell
mas install 1352778147 # bitwarden
brew install pinta
brew install gimp
brew install --cask adobe-acrobat-reader
brew install eza
brew install ripgrep
brew install fd
brew install broot
brew install duf
brew install git-delta
brew install tldr
brew install karabiner-elements

#echo "installing docker on mac..."
#brew install --cask virtualbox
#brew install docker docker-machine
#docker-machine create --driver virtualbox default

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
