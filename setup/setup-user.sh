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
mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.ssh"
mkdir -p "${HOME}/.gnupg"

echo "changing permissions..."
chmod 700 "${HOME}/.ssh"

if [ ! -d ${HOME}/.oh-my-zsh ] ; then
  echo "installing and configuring zsh stuff..."
  [ "${machine}" == "mac" ] && git clone https://github.com/ryanoasis/nerd-fonts --depth 1 ~/nerd-fonts && ~/nerd-fonts/install.sh && rm -rf ~/nerd-fonts

  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions

  wget https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion -O ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/az-completion

  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --key-bindings --completion --no-update-rc

  zsh -c 'git clone https://github.com/wting/autojump.git ~/autojump && cd ~/autojump && ./install.py && cd .. && rm -rf ~/autojump'
  mkdir -p ~/.oh-my-zsh/completions
  chmod -R 755 ~/.oh-my-zsh/completions

  git clone --depth 1 https://github.com/wulfgarpro/history-sync.git ~/history-sync
  mv ~/history-sync ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-sync
  mkdir $HOME/.zsh_history_proj && cd $HOME/.zsh_history_proj && git init

  #pip3 install tldr

  sudo chsh -s $(which zsh) $(whoami)
fi

echo "symlink/copy files..."
for i in "${DIR}"/src/bin/* ; do
  ln -sf "${i}" "${HOME}/.local/bin/$(basename "$i")"
done
for i in $(find "${DIR}/src/dotfiles" -maxdepth 1 -not -type d) ; do
  ln -sf "${i}" "${HOME}/$(basename "$i")"
done
[[ "${machine}" == "mac" ]] && ln -sf "${DIR}/src/.ssh/config.mac" "${HOME}/.ssh/config"
[[ "${machine}" != "mac" ]] && ln -sf "${DIR}/src/.ssh/config.linux" "${HOME}/.ssh/config"
[[ ! -e "${HOME}/.ssh/authorized_keys" ]] && cp "${DIR}/src/.ssh/authorized_keys" "${HOME}/.ssh/authorized_keys"
[[ ! -e "${HOME}/.ssh/known_hosts" ]] && cp "${DIR}/src/.ssh/known_hosts" "${HOME}/.ssh/known_hosts"

# create machine-specific override files (untracked, live only in $HOME).
# put local/experimental tweaks here so the dotfiles repo stays clean while
# the tracked files remain reserved for changes you intend to commit & share.
echo "creating local override files (if missing)..."
[[ ! -e "${HOME}/.zshrc.local" ]] && printf '# local zsh overrides for %s (not tracked in the dotfiles repo)\n' "$(hostname)" > "${HOME}/.zshrc.local"
[[ ! -e "${HOME}/.bashrc.local" ]] && printf '# local bash overrides for %s (not tracked in the dotfiles repo)\n' "$(hostname)" > "${HOME}/.bashrc.local"
[[ ! -e "${HOME}/.gitconfig.local" ]] && printf '# local/private git config for %s (not tracked in the dotfiles repo)\n# e.g.\n# [user]\n#\tname = Your Name\n#\temail = you@example.com\n' "$(hostname)" > "${HOME}/.gitconfig.local"

if [ "${machine}" == "mac" ] ; then
  echo "copying Library/Preferences..."
  cp src/Library/Preferences/* "${HOME}/Library/Preferences/"

  # install homebrew and brew-managed tools (mac only; on Linux these come from
  # the apt-based setup-linux.sh, so installing Homebrew here is redundant)
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew install fd
  brew install nvm
fi

echo "NOTE: remember to manually copy your ssh-keys into ${HOME}/.ssh folder, and gpg-keys to ${HOME}/.gnupg"
echo "done."
