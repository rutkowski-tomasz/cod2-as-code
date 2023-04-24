#!/bin/bash

START='\033[0;36m' # cyan
PART='\033[0;34m' # blue
DONE='\033[0;32m' # green
WARN='\033[0;33m' # yellow
NC='\033[0m' # no color

if [ -z ${1+x} ]; then
    echo -e "${WARN}Error! Usage example: ./scripts/sync_server.sh <server-name>${NC}"
    exit 1
fi

server_address=$(terraform output -raw server_address 2>/dev/null) || true
key_path=$(terraform output -raw key_path 2>/dev/null) || true

if [ -z "$server_address" ] && [ -z "$COD2_AS_CODE_SERVER_ADDRESS" ]; then
    echo -e "${WARN}Error: Terraform output doesn't contain 'server_address', please set server address env variable${NC}"
    echo -e "${WARN}Example: export COD2_AS_CODE_SERVER_ADDRESS=12.34.56.78${NC}"
    exit
elif [ -z "$server_address" ]; then
    server_address=$COD2_AS_CODE_SERVER_ADDRESS
fi

if [ -z "$key_path" ] && [ -z "$COD2_AS_CODE_KEY_NAME" ]; then
    echo -e "${WARN}Error: Terraform output doesn't contain 'key_path', please set key name env variable${NC}"
    echo -e "${WARN}Example: export COD2_AS_CODE_KEY_NAME=mykey${NC}"
    exit
elif [ -z "$key_path" ]; then
    key_path=$COD2_AS_CODE_KEY_NAME
fi

SERVER_NAME=$1

LOCAL_DIRECTORY=./setup/servers/$SERVER_NAME
if [ ! -d "$LOCAL_DIRECTORY" ]; then
    echo -e "${WARN}Error: $LOCAL_DIRECTORY does not exist.${NC}"
    exit 1
fi

echo -e "${START}Syncing local $SERVER_NAME to remote...${NC}"

echo -e "${START}Clearing server remote folder...${NC}"
ssh -i $key_path ubuntu@$server_address "rm -rf ~/cod2/servers/$SERVER_NAME/*"
echo -e "${DONE}Clearing server remote folder... done${NC}"

echo -e "${START}Uploading server files...${NC}"
scp -r -i $key_path $LOCAL_DIRECTORY ubuntu@$server_address:~/cod2/servers
echo -e "${DONE}Uploading server files... done${NC}"
