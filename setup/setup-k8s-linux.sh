#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

# install kubernetes stuff
apt-get install -y kubectl
git clone https://github.com/ahmetb/kubectx /opt/kubectx
ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -s /opt/kubectx/kubens /usr/local/bin/kubens

# install completions for oh-my-zsh
if [ -e ~/.oh-my-zsh/completions/ ] ; then
    ln -s /opt/kubectx/completion/_kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
    ln -s /opt/kubectx/completion/_kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
fi

# helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh && rm ./get_helm.sh

# Azure kubelogin
wget https://github.com/Azure/kubelogin/releases/download/v0.0.22/kubelogin-linux-amd64.zip -O /tmp/kubelogin-linux-amd64.zip
unzip /tmp/kubelogin-linux-amd64.zip && mv /tmp/bin/linux_amd64/kubelogin /usr/bin/kubelogin && rm -rf /tmp/bin && rm -rf /tmp/kubelogin*
