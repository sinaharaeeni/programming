#!/bin/bash
# Last modify 2024/05/01
# Version 2.0

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# Check if a filename is provided as an argument
if [ $# -eq 0 ]; then
    echo -e "${RED}Usage: $0 <docker-compose-file> ${RESET}"
    exit 1
fi

# Parse the YAML file to extract image names
images=$(grep -oE "image:\s*[^[:space:]]+" "$1" | awk '{print $2}')

# Print the extracted image names and pull them
echo -e "${BLUE}Images used in $1: ${RESET}"
mkdir -p pull-images
for image in $images
do {
    echo -e "\n${GREEN}Start pulling docker image $image ${RESET}"
    image_name=$( docker image inspect --format '{{ .RepoTags }}' $image | tr -d "[" | sed -r 's/[/]+/-/g' | sed -r 's/[:]+/_/g' | sed -r 's/[.]+/-/g' | tr -d "]" )
    docker image pull "$image"
    docker image save $image --output pull-images/$image_name.tar.gz
}
done
