#!/bin/bash
set -e

DOCKER_REGISTRY="${DOCKER_REGISTRY}"
DOCKER_USER="${DOCKER_USER:-merkatorgis}"
DOCKER_REPO="${DOCKER_REPO:-registry}"
DOCKER_TAG="${DOCKER_TAG:-latest}"

CONTAINER="$DOCKER_REPO"
IMAGE="${DOCKER_REGISTRY}${DOCKER_USER}/${DOCKER_REPO}:${DOCKER_TAG}"

echo; echo "Building $IMAGE"

HERE=$(dirname "$0")
"$HERE/../rename.sh" "$IMAGE" "$CONTAINER" force

if [ -d ./goproxy ]; then # building base
	which go
	cd ./goproxy
	CGO_ENABLED=0 GOOS=linux go build -a -tags netgo -ldflags '-w' .
	cd ..
	sudo docker build -t "$IMAGE" .
else # building upon base
	sudo docker build -t "$IMAGE" .
fi
