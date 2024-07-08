#!/bin/bash
# For load docker images from file
# Last modify 2024/02/21
# Version 1.4

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

# List all image in images
for image in $(ls $PWD/images/ | grep .tar )
do {
  echo -e "\n${GREEN}Loading $image${RESET}"
  docker image load --input $PWD/images/$image
  if [[ $? -eq 0 ]]; then
    rm images/$image
  fi
}
done 

# Verify all images load
if [[ $? -eq 0 ]]; then 
  echo -e "${BLUE}Load all images${RESET}"
fi

# Create report from docker images
docker images >> images-list_$(hostname)_$(date +"%Y-%m-%d")_$(date +"%H-%M-%S").txt && echo -e "${BLUE}Images list created!${RESET}"
