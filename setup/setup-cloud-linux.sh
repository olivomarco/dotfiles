#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

# install github cli
VERSION=$(curl -s "https://api.github.com/repos/cli/cli/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/' | cut -c2-)
wget -q https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.tar.gz -O /tmp/gh_${VERSION}_linux_amd64.tar.gz
tar xf /tmp/gh_${VERSION}_linux_amd64.tar.gz -C /tmp
cp /tmp/gh_${VERSION}_linux_amd64/bin/gh /usr/local/bin/
cp -r /tmp/gh_${VERSION}_linux_amd64/share/man/man1/* /usr/share/man/man1/
rm -rf /tmp/gh_${VERSION}_linux_amd64*

# add gh extensions (as the invoking user, not root)
if [ ! -z "$SUDO_USER" ] ; then
    sudo -u "$SUDO_USER" gh extension install https://github.com/nektos/gh-act 2>/dev/null || true
fi

# install az-cli (via pip — Microsoft apt repo GPG key uses SHA1, rejected by Trixie)
apt-get install -y python3-pip
pip3 install --break-system-packages azure-cli

# # install google cli
# echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
# curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.gpg > /dev/null
# apt-get update && apt-get install -y google-cloud-cli

# install terraform (direct binary — avoids lsb_release/GPG repo issues on Trixie)
TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | grep -o '"current_version":"[^"]*"' | cut -d'"' -f4)
wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform.zip
unzip -o -d /tmp /tmp/terraform.zip
mv /tmp/terraform /usr/local/bin/terraform
chmod +x /usr/local/bin/terraform
rm /tmp/terraform.zip
