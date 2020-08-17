#!/bin/bash

sudo sensors

for disk in $(ls /dev/sd[a-z]) ; do
    sudo hddtemp $disk
done
