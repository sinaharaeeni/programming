#!/bin/bash
# download and archive file from nfs
# Last modify 2024/06/15
Version=1.1

# Show file version
if [[ $1 == "-v" || $1 == "--version" ]]; then
    echo "Version $Version"
    exit 0
fi

# Function to create directory and download file
download_file() {
  local dir=$1
  local url=$2
  local file=$(basename "$url")

  mkdir -p "$dir"
  curl -o "$dir/$file" "$url"

  if [ $? -eq 0 ]; then
    echo "Downloaded $file to $dir"
  else
    echo "Failed to download $file from $url"
  fi
}

# Define nfs url address
NFS_URL=http://192.168.5.54/backend-ops

# Array of directories and files
declare -A files=(
  ["etc/sinaconsys/"]="$NFS_URL/bash-script/delete-elk-indices.sh
  $NFS_URL/bash-script/load-docker-images.sh
  $NFS_URL/bash-script/save-docker-images.sh
  $NFS_URL/bash-script/save-docker-logs.sh
  $NFS_URL/configuration/Keepalivd/Common/keepalived_push_state_cronjob.py
  $NFS_URL/configuration/Keepalivd/Common/keepalived_push_state.py"

  ["etc/systemd/system/"]="$NFS_URL/configuration/Linux-Service/python-webserver.service"

  ["etc/docker/"]="$NFS_URL/configuration/Docker/daemon.json"

  ["etc/sinaconsys/replication/"]="$NFS_URL/configuration/HA/Master/first.sh
  $NFS_URL/configuration/HA/Master/third.sh
  $NFS_URL/configuration/HA/Slave/fourth.sh
  $NFS_URL/configuration/HA/Slave/second.sh"

  ["etc/keepalive/"]="$NFS_URL/configuration/Keepalivd/Master/keepalived.conf
  $NFS_URL/configuration/Keepalivd/Master/keepalive-logger.sh
  $NFS_URL/configuration/Keepalivd/Slave/check_master_and_ping.sh
  $NFS_URL/configuration/Keepalivd/Slave/keepalived.conf
  $NFS_URL/configuration/Keepalivd/Slave/keepalive-logger.sh"
)

# Loop through the files array and download each file
for dir in "${!files[@]}"; do
  for url in ${files[$dir]}; do
    download_file "$dir" "$url"
  done
done

# Create a tar.gz archive of all the created directories
tar -czf created_directories.tar.gz etc/sinaconsys etc/systemd/system etc/docker etc/keepalive

# remove directory
rm -rf etc/*
rm -rf etc/

# echo message
echo "Created directories archived as created_directories.tar.gz"
