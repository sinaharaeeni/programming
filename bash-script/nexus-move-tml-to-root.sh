#!/bin/bash
# build on 2023/08/20
# Version 1.1

docker login http://repo.sinacomsys.local:8083 --username repo-update --password repo-update

for services in $( curl -s  http://192.168.5.61:9099/service/rest/repository/browse/docker-private/v2/dwdm/master/ | awk -F'<td><a href="|</a></td>' '{print $2}' |  tr -s '\n' '\n' | cut -d ">" -f 2); do
	for ImageName in $(docker image ls --filter "reference=repo.sinacomsys.local:8083/dwdm/master/$services" --format {{.Repository}}:{{.Tag}}); do
		for ImageTag in $(docker image ls --filter "reference=$ImageName" --format {{.Tag}}); do
			NewImageName=repo.sinacomsys.local:8083/dwdm/$services:$ImageTag
      docker pull $ImageName
			docker image tag $ImageName $NewImageName
			docker push $NewImageName
			docker image rm $ImageName
			docker image rm $NewImageName
		done
	done
done
