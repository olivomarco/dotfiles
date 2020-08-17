#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

apt-get install -y git wget curl vim lynx dnsutils bash-completion git-core \
    screen ntp jq htop psmisc netcat net-tools gnupg gnupg-agent nmap gzip mlocate rsync \
    sudo dos2unix unzip openssl software-properties-common apt-transport-https \
    linux-headers-$(uname -r) build-essential dkms tasksel \
    python3 python3-pip python3-venv zsh console-data
