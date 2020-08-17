#!/bin/bash

if [ "$(uname -s)" != "Linux" ] ; then
    echo "current machine is not linux."
    exit 1
fi

echo "updating local server..."
sudo apt-get update ; sudo apt-get -y upgrade ; sudo apt-get -y dist-upgrade; sudo apt-get -y autoremove
echo "done."
