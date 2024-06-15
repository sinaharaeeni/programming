#!/bin/bash
# For add docker images to local nexus repository
# Last modify 2024/06/15
Version=1.5

# Show file version
if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "Version $Version"
    exit 0
fi

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Error massage
error_message() {
echo -e "${RED}----------------------------------------------------------------${RESET}"
echo -e "${RED}This script build for download and upload docker image to nexus.${RESET}"
echo -e "${RED}First argument: image name : flavor or version${RESET}"
echo -e "${RED}Example: add-general-image-to-nexus.sh alpine:latest${RESET}"
echo -e "${RED}----------------------------------------------------------------${RESET}"
exit 1
};

# Check enter docker image name
if [ -z "$1" ]; then
    error_message;
fi

# Define repository address
REPO_URL=repo.sinacomsys.local:8083
REPO_USER=repo-update
REPO_PASS=repo-update

# Download docker image
docker pull $1

if [[ $? -eq 0 ]]; then
    # Change image name
    docker tag $1 $REPO_URL/general/$1

    # Login to nexus repository
    docker login http://$REPO_URL --username $REPO_USER --password $REPO_PASS

    # Push docker image to nexus repository
    docker push $REPO_URL/general/$1

    if [[ $? -eq 0 ]]; then
        # Remove orginal docker image 
        docker image rm $1

        # Remove repo docker image
        docker image rm $REPO_URL/general/$1
    fi
fi
