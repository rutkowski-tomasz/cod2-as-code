#!/bin/bash

if [[ -z "${KEYNAME}" ]]; then
    echo "First set env variable KEYNAME"
    exit 1
fi

if [[ -z "${SERVER}" ]]; then
    echo "First set env variable KEYNAME"
    exit 1
fi

if [ -z ${1+x} ]; then
    echo "Error! Usage example: ./scripts/add_server.sh <fs-game>"
    exit 1
fi

FS_GAME=$1

LOCAL_DIRECTORY=./setup/servers/$FS_GAME
if [ ! -d "$LOCAL_DIRECTORY" ]; then
    echo "$LOCAL_DIRECTORY does not exist."
    exit 1
fi

LOCAL_DOCKER_COMPOSE=./setup/servers/docker-compose/$FS_GAME/docker-compose.yml
if [ ! -f "$LOCAL_DOCKER_COMPOSE" ]; then
    echo "$LOCAL_DOCKER_COMPOSE does not exist."
    exit 1
fi

echo "Syncing local $FS_GAME to remote"

echo "Clearing FS_GAME remote folder..."
ssh -i ~/.ssh/$KEYNAME ubuntu@$SERVER "rm -rf ~/servers/$FS_GAME/*"
echo "Clearing FS_GAME remote folder... done"

echo "Clearing remote docker-compose..."
ssh -i ~/.ssh/$KEYNAME ubuntu@$SERVER "rm ~/servers/docker-compose/$FS_GAME/docker-compose.yml"
echo "Clearing remote docker-compose... done"

echo "Uploading server files..."
scp -r -i ~/.ssh/$KEYNAME $LOCAL_DIRECTORY ubuntu@$SERVER:/home/ubuntu/servers/
echo "Uploading server files... done"

echo "Creating docker-compose folder..."
ssh -i ~/.ssh/$KEYNAME ubuntu@$SERVER "mkdir -p ~/servers/docker-compose/$FS_GAME"
echo "Creating docker-compose folder... done"

echo "Uploading docker-compose..."
scp -r -i ~/.ssh/$KEYNAME $LOCAL_DOCKER_COMPOSE ubuntu@$SERVER:~/servers/docker-compose/$FS_GAME/docker-compose.yml
echo "Uploading docker-compose... done"
