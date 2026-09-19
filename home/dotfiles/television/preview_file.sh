#!/usr/bin/env bash

if [ "$#" -eq 1 ] && [[ "$1" =~ \.(png|jpg|jpeg|gif|webp)$ ]]; then
    # kitten icat --transfer-mode=file "$1"
    echo "$1 is Image"
else
    bat --color=always -n "$@"
fi
