#!/bin/bash
# Delete old indices in elastic
# Last modify 2024/06/15
Version 2.0

# Show file version
if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "Version $Version"
    exit 0
fi

SAVE_BEFORE_DAY="-3"
USERNAME_PASSWORD="elastic:elastic"

# shelf indices
for index_shelf in $( curl --silent --user $USERNAME_PASSWORD "http://localhost:9106/_cat/indices/shelf-*?pri&h=index" | sort | head -n $SAVE_BEFORE_DAY ) 
do {
    curl --user $USERNAME_PASSWORD -XDELETE localhost:9106/$index_shelf
}
done

# container indices
for index_container in $( curl --silent --user $USERNAME_PASSWORD "http://localhost:9106/_cat/indices/container-*?pri&h=index" | sort | head -n $SAVE_BEFORE_DAY ) 
do {
    curl --user $USERNAME_PASSWORD -XDELETE localhost:9106/$index_container
}
done
