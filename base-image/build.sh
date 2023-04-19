#!/bin/bash -ex
# This script is created by Lonsonfore (https://github.com/Lonsofore/cod2docker/blob/master/scripts/build.sh)

IMAGE_NAME=${1:-lonsofore/cod2}
VER=${2:-0}  # 1.0

docker_version=$(cat __version__)
tag="${IMAGE_NAME}:1.${VER}"
full_tag="${tag}-${docker_version}"
ver1="1_${VER}"

docker build \
    --build-arg cod2_version="${ver1}" \
    --build-arg libcod_mysql=1 \
    --build-arg libcod_sqlite=1 \
    -t $tag \
    -t $full_tag \
    .
