#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

# install kubectl
KUBECTL_VERSION=$(wget -qO- https://dl.k8s.io/release/stable.txt)
wget -O /usr/local/bin/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x /usr/local/bin/kubectl

# install kubectx/kubens
git clone https://github.com/ahmetb/kubectx /opt/kubectx 2>/dev/null || git -C /opt/kubectx pull
ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -sf /opt/kubectx/kubens /usr/local/bin/kubens

# install completions for oh-my-zsh
if [ -e ~/.oh-my-zsh/completions/ ] ; then
    ln -sf /opt/kubectx/completion/_kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
    ln -sf /opt/kubectx/completion/_kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
fi

# helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh && rm ./get_helm.sh

# Azure kubelogin
KUBELOGIN_VERSION=0.1.6
wget https://github.com/Azure/kubelogin/releases/download/v${KUBELOGIN_VERSION}/kubelogin-linux-amd64.zip -O /tmp/kubelogin-linux-amd64.zip
unzip -o -d /tmp /tmp/kubelogin-linux-amd64.zip && mv /tmp/bin/linux_amd64/kubelogin /usr/local/bin/kubelogin && rm -rf /tmp/bin && rm -rf /tmp/kubelogin*
