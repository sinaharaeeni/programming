#!/bin/bash
# build on 2023/08/20
# Version 1.1

docker login http://repo.sinacomsys.local:8083 --username repo-update --password repo-update

for im in $( ls images/ | grep .tar ) 
do {
 echo "Loading $im"
 ver=$(docker image load --input images/$im --quiet | sed 's/Loaded image: //g')
 docker tag $ver repo.sinacomsys.local:8083/olt/$ver
 docker push repo.sinacomsys.local:8083/olt/$ver --quiet
 docker image rm $ver
 docker image rm repo.sinacomsys.local:8083/olt/$ver
 rm images/$im
 }
done && echo "Upload all images"
