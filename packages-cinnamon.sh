#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "must run as root"
        exit
fi

echo "=====> downloading packages for cinnamon desktop"
echo
# requires sudo
# --noconfirm is used to select all packages from groups
pacman -Sy --needed $(<packages-cinnamon.txt)
