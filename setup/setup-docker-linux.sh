#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi
if [ $EUID -ne 0 ] ; then
   echo "This script must be run as root" 
   exit 1
fi

# install docker (via official convenience script — handles repo/GPG setup for all distros)
curl -fsSL https://get.docker.com | sh

# add the invoking user to the docker group
if [ ! -z "$SUDO_USER" ] ; then
    usermod -aG docker "$SUDO_USER"
fi
