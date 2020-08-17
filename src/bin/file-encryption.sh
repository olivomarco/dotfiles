#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ] ; then
    echo "USAGE: $0 encrypt|decrypt filename"
    exit
fi

command="$1"
filename="$2"

if [ "$command" == "encrypt" ] ; then
    echo "Encrypting..."
    cat "$filename" | openssl enc -e -aes128 -base64 > "$filename.2"
    mv "$filename.2" "$filename"
    echo "done."
else
    echo "Decrypting..."
    cat "$filename" | openssl enc -d -aes128 -base64 > "$filename.2"
    mv "$filename.2" "$filename"
    echo "done."
fi
