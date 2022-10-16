#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

# install dotnet sdk
wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update; apt-get install -y apt-transport-https && apt-get update && apt-get install -y aspnetcore-runtime-5.0

# install java stuff
apt-get install -y default-jdk maven

# install nodejs and python
apt-get install -y python3 python3-pip python3-venv nodejs python-is-python3
