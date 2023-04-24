#!/bin/bash

while [ $# -gt 0 ]; do
    case "$1" in
        --mysql_root_password=*)
        mysql_root_password="${1#*=}"
        ;;
        --aws_access_key_id=*)
        aws_access_key_id="${1#*=}"
        ;;
        --aws_secret_access_key=*)
        aws_secret_access_key="${1#*=}"
        ;;
        --s3_bucket_name=*)
        s3_bucket_name="${1#*=}"
        ;;
        --s3_bucket_region=*)
        s3_bucket_region="${1#*=}"
        ;;
        --domain=*)
        domain="${1#*=}"
        ;;
        *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
    shift
done

for arg_name in "mysql_root_password" "domain"; do
arg_value=$(eval echo \$$arg_name)
if [ -z "$arg_value" ]; then
    echo "Error: Missing argument --${arg_name}"
    exit 1
fi
done

ABSOLUTE_FILENAME=$(readlink -e "$0")
DIRECTORY=$(dirname "$ABSOLUTE_FILENAME")

# Run scripts
$DIRECTORY/parts/requirements.sh
$DIRECTORY/parts/envsubst.sh $mysql_root_password $domain
$DIRECTORY/parts/cod2.sh $s3_bucket_name $s3_bucket_region $aws_access_key_id $aws_secret_access_key

# Start services
sg docker -c "cd ~/lamp && docker-compose up -d 1> /dev/null"
sg docker -c "cd ~/reverse-proxy && docker-compose up -d 1> /dev/null"
for dir in ~/cod2/servers/*/; do
    sg docker -c "cd $dir && docker-compose up -d 1> /dev/null"
done
