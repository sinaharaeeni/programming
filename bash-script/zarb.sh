#!/bin/bash
# Created on: 2024/05/07
# Last modify: 2024/05/07
# Description: print matrix
# Version: 3.0

for i in $(seq 1 $1)
do
    for j in $(seq 1 $2)
    do
        if [ $i -eq $j ];then
            echo -n "*****   "
        else
            let s=$i*$j
            echo -n "$i*$j=$s   "
        fi
    done
    echo ""
done
