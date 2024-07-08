#!/bin/bash
# build on 2023/04/20
# modify on 2023/08/20
# Version 1.2

docker login http://repo.sinacomsys.local:8083 --username repo-update --password repo-update

for ImageId in $( docker image ls --quiet ) 
do {

echo "Preparing $ImageId"
ImageName=$( docker image inspect --format '{{ .RepoTags }}' $ImageId | tr -d "[" | tr -d "]" |  cut -d ' ' -f1 )
docker tag $ImageName repo.sinacomsys.local:8083/general/$ImageName
docker push repo.sinacomsys.local:8083/general/$ImageName
docker image rm $ImageName
docker image rm repo.sinacomsys.local:8083/general/$ImageName

}
done && echo "Upload all file images"
