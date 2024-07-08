#!/bin/bash
# build on 2023/09/25
# Version 1.2

error_message() {
echo "----------------------------------"
echo "This script build for push local and file image to Nexus repository. "
echo "Example for load local images: bash repo-uploader-general.sh local"
echo "Example for load file images: bash repo-uploader-general.sh file"
echo "----------------------------------"
exit 1
};

if [ -z "$1" ]
then
    error_message;
else
    ImageSource=$1;
fi

# login to nexus
docker login http://repo.sinacomsys.local:8083 --username repo-update --password repo-update

# check image source
if [[ $? -eq 0 ]]; then
    # task for local images - docker images
    if ($ImageSource=local) ; then {
        for ImageId in $( docker image ls --quiet ) 
        do {
            echo "Preparing $ImageId"
            # create image name from RepoTags
            ImageName=$( docker image inspect --format '{{ .RepoTags }}' $ImageId | tr -d "[" | tr -d "]" |  cut -d ' ' -f1 )
            # change image name to repository
            docker tag $ImageName repo.sinacomsys.local:8083/$ImageName
            # check last command if normall start upload to nexus
            if [[ $? -eq 0 ]]; then
                docker push repo.sinacomsys.local:8083/$ImageName --quiet
            fi
        }
    done && echo "Upload all local images"

    # task for file image - *.tar.gz in images directory
    } elif ($ImageSource=file) ; then {
        for im in $( ls images/ | grep .tar ) 
        do {
            echo "Loading $im"
            # load image and create image name from loaded image
            name_tag=$(docker image load --input images/$im --quiet | sed 's/Loaded image: //g')
            # change image name to repository
            docker tag $name_tag repo.sinacomsys.local:8083/$name_tag
            # check last command if normall start upload to nexus
            if [[ $? -eq 0 ]]; then
                docker push repo.sinacomsys.local:8083/$name_tag --quiet
            fi
        }
    done && echo "Upload all file images"

    }
    else
        error_message;
    fi
fi