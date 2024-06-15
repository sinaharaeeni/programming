#!/bin/bash
# For cleanup and delete unuse docker image and container
# Last modify 2024/06/15
Version=1.2

# Show file version
if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "Version $Version"
    exit 0
fi

docker container rm $(docker ps -a -q)
docker rmi $(docker images -f "dangling=true" -q)
