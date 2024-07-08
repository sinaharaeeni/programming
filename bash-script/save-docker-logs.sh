#!/bin/bash
# build on 2023/09/21
# Version 2.0

# create folder name with hostname and current date
FolderName=docker-logs_$(hostname)_$(date +"%Y-%m-%d")_$(date +"%H-%M-%S")

# create directory for archive logs
mkdir -p "$FolderName"
if [[ $? -eq 0 ]]; then
  for ContainerId in $(docker container ls --all --quiet)
    do {
      # export container name
      ContainerName=$(docker inspect --format='{{.Name}}' $ContainerId | cut -c 2- )
      # save container log
      echo "Saving log from container $ContainerName"
      docker logs $ContainerId >> $FolderName/$ContainerName.txt 2>&1 >/dev/null
    }
  done
  # save all contianer list in file
  docker container ls --all >> $FolderName/container-list.txt
fi

# if previous step run successfully, compress folder
if [[ $? -eq 0 ]]; then
  tar -zcf $FolderName.tar.gz $FolderName
fi

# if previous step run successfully, remove folder
if [[ $? -eq 0 ]]; then
  rm -rf $FolderName
fi

# if previous step run successfully, show message end work
if [[ $? -eq 0 ]]; then
  echo -e "\nSave all docker logs successfully! \nNow you can copy '$FolderName.tar.gz' for move."
fi
