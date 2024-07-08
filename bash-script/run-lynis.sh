#!/bin/bash
# Last modify 2023/10/07
# Version 1.1

mkdir -p /home/lynis
    if [[ $? -eq 0 ]]; then
        cd /home/lynis
        if [[ $? -eq 0 ]]; then
            wget https://downloads.cisofy.com/lynis/lynis-3.0.9.tar.gz
            if [[ $? -eq 0 ]]; then
                tar -xzvf lynis-3.0.9.tar.gz
                if [[ $? -eq 0 ]]; then
                    rm lynis-3.0.9.tar.gz
                    if [[ $? -eq 0 ]]; then
                        cd lynis
                        if [[ $? -eq 0 ]]; then
                            ./lynis audit system
                        fi
                    fi
                fi
            fi
        fi
    fi
fi
