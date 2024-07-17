#!/bin/bash -e

VERSION=`cat VERSION`
IMAGE=thinmanager/terminal_proxy_ignition_vision

docker run --rm -it -p 3390:3389 -e USER_PASSWORD=z $IMAGE:$VERSION /sbin/my_init -- /bin/bash -l

