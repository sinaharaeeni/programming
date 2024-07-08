#!/bin/bash
# Last modify 2023/08/20
# Version 1.1

docker login http://repo.sinacomsys.local:8083 --username repo-update --password repo-update
docker login http://192.168.1.39:8094 --username admin --password nexusAdmin

for services in $(curl -s http://192.168.1.39:8093/service/rest/repository/browse/docker-images/v2/admin/ | awk -F'<td><a href="|</a></td>' '{print $2}' |  tr -s '\n' '\n' | cut -d ">" -f 2); do
	echo services=======$services
  docker pull --all-tags 192.168.1.39:8094/admin/$services
	for ImageName in $(docker image ls --filter "reference=192.168.1.39:8094/admin/$services" --format {{.Repository}}:{{.Tag}}); do
		echo ImageName========$ImageName
		for ImageTag in $(docker image ls --filter "reference=$ImageName" --format {{.Tag}}); do
			NewImageName=repo.sinacomsys.local:8083/olt/$services:$ImageTag
			echo NewImageName=========$NewImageName
			docker pull $ImageName
			docker image tag $ImageName $NewImageName
			docker push $NewImageName
			docker image rm $ImageName
			docker image rm $NewImageName
		done
	done
done
