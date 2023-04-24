#!/bin/bash

START='\033[0;36m' # cyan
PART='\033[0;34m' # blue
DONE='\033[0;32m' # green
WARN='\033[0;33m' # yellow
NC='\033[0m' # no color

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

ssh -i $key_path ubuntu@$server_address
