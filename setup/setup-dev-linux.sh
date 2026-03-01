#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

# install dotnet sdk (via install script — avoids broken Microsoft apt repo on Trixie)
wget https://dot.net/v1/dotnet-install.sh -O /tmp/dotnet-install.sh
chmod +x /tmp/dotnet-install.sh
/tmp/dotnet-install.sh --channel 9.0 --install-dir /usr/share/dotnet
ln -sf /usr/share/dotnet/dotnet /usr/local/bin/dotnet
rm /tmp/dotnet-install.sh

# install azd
curl -fsSL https://aka.ms/install-azd.sh | bash

# install java stuff
apt-get install -y default-jdk maven

# install nodejs and python
apt-get install -y python3 python3-pip python3-venv nodejs python-is-python3
