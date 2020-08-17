#!/bin/bash

if [ "$(uname -s)" != "Darwin" ] ; then
    echo "current machine is not mac."
    exit 1
fi

docker-machine stop default
