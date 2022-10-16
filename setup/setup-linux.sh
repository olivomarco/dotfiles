#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

# install various packages
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git wget curl vim lynx dnsutils bash-completion git-core \
    screen ntp jq htop psmisc netcat net-tools gnupg gnupg-agent nmap gzip mlocate rsync \
    sudo dos2unix unzip openssl software-properties-common apt-transport-https \
    build-essential dkms tasksel console-data zsh snapd
snap install ngrok

# install bat
BAT_VERSION=0.18.0
BAT_ARCHTYPE=amd64
wget https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat_${BAT_VERSION}_${BAT_ARCHTYPE}.deb \
    -O /tmp/bat_${BAT_VERSION}_${BAT_ARCHTYPE}.deb && \
dpkg -i /tmp/bat_${BAT_VERSION}_${BAT_ARCHTYPE}.deb && \
rm /tmp/bat_${BAT_VERSION}_${BAT_ARCHTYPE}.deb
