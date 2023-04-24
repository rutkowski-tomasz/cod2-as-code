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
        --s3_bukcet_region=*)
        s3_bukcet_region="${1#*=}"
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

for arg_name in "mysql_root_password" "aws_access_key_id" "aws_secret_access_key" "s3_bucket_name" "s3_bukcet_region" "domain"; do
arg_value=$(eval echo \$$arg_name)
if [ -z "$arg_value" ]; then
    echo "Error: Missing argument --${arg_name}"
    exit 1
fi
done

$cwd=$(pwd)
echo "Executing in $cwd"

# Requirements
$cwd/parts/requirements.sh
$cwd/parts/envsubst.sh $mysql_root_password $domain

# CoD2
export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key

$cwd/parts/cod2.sh $s3_bucket_name $s3_bukcet_region

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

# Start services
sudo docker-compose -f ~/cod2/servers/nl-example/docker-compose.yml up -d 1> /dev/null
sudo docker-compose -f ~/reverse-proxy/docker-compose.yml up -d 1> /dev/null
sudo docker-compose -f ~/lamp/docker-compose.yml up -d 1> /dev/null
