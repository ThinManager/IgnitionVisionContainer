#!/bin/bash -e

APP=ignition_vision
VERSION=`cat VERSION`

TAG=thinmanager/terminal_proxy_$APP:$VERSION
IMAGE_FILENAME=terminal_proxy_$APP-$VERSION.tar

# metadata to tell ThinManager the details of the container
cat << EOF > label.json
[
	{
		"Id": "$APP",
		"Description": "ignition_vision",
		"Command": "/start.sh"
	}
]
EOF

# properly escape the json text
LABEL="com.thinmanager.apps=\"`python3 -c 'import json, sys; print(json.dumps(json.dumps(json.load(open("label.json")), separators=(",",":")))[1:-1])'`\""
echo LABEL=$LABEL

# build the Dockerfile on the fly
cat << EOF > Dockerfile.$APP
FROM thinmanager/terminal_proxy_chrome:14.0.0

COPY start.sh build.sh install.sh run.sh vision-client-launcher.json /

COPY visionclientlauncher/ ./visionclientlauncher

RUN chmod +x /*.sh && chmod -R 777 /visionclientlauncher/ && chmod +x /visionclientlauncher/app/visionclientlauncher.sh && /install.sh && rm -rf /install.sh && chmod 777 /vision-client-launcher.json

LABEL $LABEL
EOF

sudo docker rmi -f $TAG
sudo docker builder prune -f
sudo docker build --squash -t $TAG -f Dockerfile.$APP --progress=plain .

rm -f label.json Dockerfile.$APP

# export image
echo "$TAG ==> $IMAGE_FILENAME"
sudo docker save $TAG > $IMAGE_FILENAME 
sudo chown $USER:$USER $IMAGE_FILENAME

gzip -f $IMAGE_FILENAME


