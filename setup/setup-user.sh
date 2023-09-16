#!/bin/bash

# get current machine type
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     machine=linux;;
  Darwin*)    machine=mac;;
  CYGWIN*)    machine=cygwin;;
  MINGW*)     machine=mingw;;
  *)          machine="UNKNOWN:${unameOut}"
esac
echo "machine type detected is: ${machine}"

# get current script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.."

# main
echo "doing setup for user ${USER}..."

echo "creating bin, .ssh and .gnupg folders..."
mkdir ${HOME}/bin || true
mkdir ${HOME}/.ssh || true
mkdir ${HOME}/.gnupg || true

echo "changing permissions..."
chmod 700 ${HOME}/.ssh

if [ ! -d ${HOME}/.oh-my-zsh ] ; then
  echo "installing and configuring zsh stuff..."
  [ "${machine}" == "mac" ] && git clone https://github.com/ryanoasis/nerd-fonts --depth 1 ~/nerd-fonts && ~/nerd-fonts/install.sh && rm -rf ~/nerd-fonts

  curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

  git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

  wget https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion -O ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/az-completion

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --key-bindings --completion --no-update-rc

  pip3 install thefuck

  zsh -c 'git clone https://github.com/wting/autojump.git ~/autojump && cd ~/autojump && ./install.py && cd .. && rm -rf ~/autojump'
  mkdir -p ~/.oh-my-zsh/completions
  chmod -R 755 ~/.oh-my-zsh/completions

  git clone --depth 1 https://github.com/wulfgarpro/history-sync.git ~/history-sync
  mv ~/history-sync ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-sync
  mkdir $HOME/.zsh_history_proj && cd $HOME/.zsh_history_proj && git init

  pip3 install tldr

  sudo chsh -s $(which zsh) $(whoami)
fi

echo "symlink/copy files..."
for i in ${DIR}/src/bin/* ; do
  ln -sf ${i} ${HOME}/bin/$(basename $i)
done
for i in $(find ${DIR}/src/dotfiles -maxdepth 1 -not -type d) ; do
  ln -sf ${i} ${HOME}/$(basename $i)
done
[[ "${machine}" == "mac" ]] && ln -sf ${DIR}/src/.ssh/config.mac ${HOME}/.ssh/config
[[ "${machine}" != "mac" ]] && ln -sf ${DIR}/src/.ssh/config.linux ${HOME}/.ssh/config
[[ ! -e ${HOME}/.ssh/authorized_keys ]] && cp ${DIR}/src/.ssh/authorized_keys ${HOME}/.ssh/authorized_keys
[[ ! -e ${HOME}/.ssh/known_hosts ]] && cp ${DIR}/src/.ssh/known_hosts ${HOME}/.ssh/known_hosts
[[ "${machine}" == "mac" ]] && ln -sf /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport $HOME/bin/airport

if [ "${machine}" == "mac" ] ; then
  echo "copying Library/Preferences..."
  cp src/Library/Preferences/* ${HOME}/Library/Preferences/
fi

p=${HOME}/.local/bin
[ ! -e $p ] && mkdir -p $p

echo "NOTE: remember to manually copy your ssh-keys into ${HOME}/.ssh folder, and gpg-keys to ${HOME}/.gnupg"
echo "done."
