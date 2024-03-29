#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

# download helper script to configure server
wget https://raw.githubusercontent.com/Nyr/openvpn-install/master/openvpn-install.sh -O /tmp/openvpn-install.sh
chmod +x /tmp/openvpn-install.sh
# install openvpn
bash /tmp/openvpn-install.sh
