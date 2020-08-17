#!/bin/bash

if [ "$(uname -s)" != "Darwin" ] ; then
    echo "current machine is not mac."
    exit 1
fi

echo "updating local mac..."
brew update && brew upgrade
echo "done."
