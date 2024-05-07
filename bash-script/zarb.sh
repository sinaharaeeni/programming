#!/bin/bash
# Created on: 2024/05/07
# Last modify: 2024/05/07
# Description: print matrix
# Version: 1.0 

for i in $(seq 1 3)
do
    for j in $(seq 1 3)
    do
        let s=$i*$j
        echo -n "$i*$j=$s   "
    done
    echo ""
done