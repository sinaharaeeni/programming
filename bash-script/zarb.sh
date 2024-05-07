#!/bin/bash
# Created on: 2024/05/07
# Last modify: 2024/05/07
# Description: print matrix
# Version: 2.0

for i in $(seq 1 $1)
do
    for j in $(seq 1 $2)
    do
        let s=$i*$j
        echo -n "$i*$j=$s   "
    done
    echo ""
done