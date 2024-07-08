#!/bin/bash
# build on 2023/08/05
# Version 1.3

mkdir -p old-images

for image_id in $( docker images --quiet ) 
do {
  image_save_name=$( docker image inspect --format '{{ .RepoTags }}' $image_id | tr -d "[" | tr -d "]" )
  image_name=$( docker image inspect --format '{{ .RepoTags }}' $image_id | tr -d "[" | sed -r 's/[/]+/-/g' | sed -r 's/[:]+/_/g' | sed -r 's/[.]+/-/g' | tr -d "]" )
  docker image save $image_save_name --output old-images/$image_name.tar.gz
  echo "Saved $image_name"
  }
done && echo "save all images"
