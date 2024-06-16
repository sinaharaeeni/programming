#!/bin/bash
# For combine file environment with yaml template to one file
# Last modify 2024/06/16
Version=1.0

# Show file version
if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "Version $Version"
    exit 0
fi

# Read docker-template.yaml into a variable
compose_file="docker-template.yaml"
combined_file="docker-compose.yaml"
environment_file="environment.env"

# Check compose file file exist and read the docker template content
if [[ ! -f "$compose_file" ]]; then
    echo "$compose_file not found!"
    exit 1
else
    compose_content=$(cat "$compose_file")
fi

# Check environment file exist and load environment variables
if [[ ! -f "$environment_file" ]]; then
    echo "$environment_file not found!"
    exit 1
else
    set -a
    source $environment_file
    set +a
fi

# Substitute environment variables in the docker template content
for var in $(cat $environment_file | cut -d '=' -f 1); do
    value=$(eval echo \$$var)
    placeholder="\${${var}}"
    compose_content=${compose_content//$placeholder/$value}
done

# Save the updated content to a new file
echo "$compose_content" > "$combined_file"

echo "Combined Docker Compose file created as '$combined_file'"
