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

# install various packages
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git wget curl vim lynx dnsutils bash-completion git-core \
    screen ntp jq htop psmisc net-tools netcat-openbsd gnupg gnupg-agent nmap gzip mlocate rsync \
    sudo dos2unix unzip openssl software-properties-common apt-transport-https \
    build-essential dkms tasksel console-data zsh snapd exa ncal
snap install ngrok

# install bat
BAT_VERSION=0.18.0
wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${ARCHTYPE}.deb \
    -O /tmp/bat_${BAT_VERSION}_${ARCHTYPE}.deb && \
dpkg -i /tmp/bat_${BAT_VERSION}_${ARCHTYPE}.deb && \
rm /tmp/bat_${BAT_VERSION}_${ARCHTYPE}.deb

# install duf
DUF_VERSION=0.8.1
wget https://github.com/muesli/duf/releases/download/v${DUF_VERSION}/duf_${DUF_VERSION}_linux_${ARCHTYPE}.deb \
    -O /tmp/bat_${DUF_VERSION}_${ARCHTYPE}.deb && \
dpkg -i /tmp/bat_${DUF_VERSION}_${ARCHTYPE}.deb && \
rm /tmp/bat_${DUF_VERSION}_${ARCHTYPE}.deb

# install fd
apt-get install -y fd-find
if [ ! -z $SUDO_USER ] ; then
	ln -s $(which fdfind) /home/${SUDO_USER}/.local/bin/fd
else
	ln -s $(which fdfind) /root/.local/bin/fd
fi;

# install ripgrep
RG_VERSION=13.0.0
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep_${RG_VERSION}_${ARCHTYPE}.deb
dpkg -i ripgrep_${RG_VERSION}_${ARCHTYPE}.deb && rm ripgrep_${RG_VERSION}_${ARCHTYPE}.deb

# install delta
DELTA_VERSION=0.16.5
wget https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_${ARCHTYPE}.deb \
    -O /tmp/bat_${DELTA_VERSION}_${ARCHTYPE}.deb && \
dpkg -i /tmp/bat_${DELTA_VERSION}_${ARCHTYPE}.deb && \
rm /tmp/bat_${DELTA_VERSION}_${ARCHTYPE}.deb

# install broot
wget https://dystroy.org/broot/download/x86_64-linux/broot && mv broot /usr/local/bin && chmod +x /usr/local/bin/broot
