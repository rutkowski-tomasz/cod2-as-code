#!/bin/bash

if [[ -z "${KEYNAME}" ]]; then
    echo "First set env variable KEYNAME"
    exit 1
fi

if [[ -z "${SERVER}" ]]; then
    echo "First set env variable SERVER"
    exit 1
fi

if [ -z ${1+x} ]; then
    echo "Error! Usage example: ./scripts/sync_server.sh <server-name>"
    exit 1
fi

SERVER_NAME=$1

LOCAL_DIRECTORY=./setup/servers/$SERVER_NAME
if [ ! -d "$LOCAL_DIRECTORY" ]; then
    echo "$LOCAL_DIRECTORY does not exist."
    exit 1
fi

echo "Syncing local $SERVER_NAME to remote"

echo "Clearing server remote folder..."
ssh -i ~/.ssh/$KEYNAME ubuntu@$SERVER "rm -rf ~/cod2/servers/$SERVER_NAME/*"
echo "Clearing server remote folder... done"

echo "Uploading server files..."
scp -r -i ~/.ssh/$KEYNAME $LOCAL_DIRECTORY ubuntu@$SERVER:~/cod2/servers
echo "Uploading server files... done"
