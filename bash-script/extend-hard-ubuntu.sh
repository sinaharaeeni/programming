#!/bin/bash
# For extend lvm hard in ubuntu
# Last modify 2024/06/15
Version=1.2

# Show file version
if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "Version $Version"
    exit 0
fi

if [[ $? -eq 0 ]]; then
    pvresize /dev/sda3
    if [[ $? -eq 0 ]]; then
        lvextend -l+100%FREE /dev/ubuntu-vg/ubuntu-lv
        if [[ $? -eq 0 ]]; then
        resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
        fi
    fi
fi
