#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

ARCHTYPE=amd64

# resolve the latest release tag for a GitHub repo (raw tag, e.g. "v1.2.3" or "1.2.3")
latest_release() {
    curl -s "https://api.github.com/repos/$1/releases/latest" \
        | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/'
}

# install various packages
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git wget curl vim lynx dnsutils bash-completion \
    screen ntpsec jq yq htop psmisc net-tools netcat-openbsd gnupg gnupg-agent nmap gzip plocate rsync \
    sudo dos2unix unzip openssl apt-transport-https \
    build-essential dkms tasksel zsh ncal gpg tree

# # install eza
# mkdir -p /etc/apt/keyrings
# wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
# echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
# chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
# apt-get update
# apt-get install -y eza

# install brew
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install bat
BAT_VERSION=$(latest_release sharkdp/bat); BAT_VERSION=${BAT_VERSION#v}
wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${ARCHTYPE}.deb \
    -O /tmp/bat_${BAT_VERSION}_${ARCHTYPE}.deb && \
dpkg -i /tmp/bat_${BAT_VERSION}_${ARCHTYPE}.deb && \
rm /tmp/bat_${BAT_VERSION}_${ARCHTYPE}.deb

# install duf
DUF_VERSION=$(latest_release muesli/duf); DUF_VERSION=${DUF_VERSION#v}
wget https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_${ARCHTYPE}.deb \
    -O /tmp/duf_${DUF_VERSION}_${ARCHTYPE}.deb && \
dpkg -i /tmp/duf_${DUF_VERSION}_${ARCHTYPE}.deb && \
rm /tmp/duf_${DUF_VERSION}_${ARCHTYPE}.deb

# install fd
apt-get install -y fd-find
if [ ! -z $SUDO_USER ] ; then
    p=/home/${SUDO_USER}/.local/bin
else
    p=/root/.local/bin
fi;
[ ! -e $p ] && mkdir -p $p
ln -sf $(which fdfind) $p/fd

# install ripgrep
RG_VERSION=$(latest_release BurntSushi/ripgrep); RG_VERSION=${RG_VERSION#v}
wget https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep_${RG_VERSION}_${ARCHTYPE}.deb \
    -O /tmp/ripgrep_${RG_VERSION}_${ARCHTYPE}.deb && \
dpkg -i /tmp/ripgrep_${RG_VERSION}_${ARCHTYPE}.deb && \
rm /tmp/ripgrep_${RG_VERSION}_${ARCHTYPE}.deb

# install delta
DELTA_VERSION=$(latest_release dandavison/delta); DELTA_VERSION=${DELTA_VERSION#v}
wget https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCHTYPE}.deb \
    -O /tmp/git-delta_${DELTA_VERSION}_${ARCHTYPE}.deb && \
dpkg -i /tmp/git-delta_${DELTA_VERSION}_${ARCHTYPE}.deb && \
rm /tmp/git-delta_${DELTA_VERSION}_${ARCHTYPE}.deb

# # install broot
# wget https://dystroy.org/broot/download/x86_64-linux/broot && mv broot /usr/local/bin && chmod +x /usr/local/bin/broot
