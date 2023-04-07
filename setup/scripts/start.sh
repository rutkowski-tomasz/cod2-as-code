#!/bin/bash

source parts/parse_arguments.sh

args=$(parse_arguments "$@")
if [ $? -ne 0 ]; then
    echo $args
    exit $?
fi

IFS=' ' read -ra parsed_args <<< "$args"

mysql_password=${parsed_args[0]}
user_name=${parsed_args[1]}
user_password=${parsed_args[2]}
aws_access_key_id=${parsed_args[3]}
aws_secret_access_key=${parsed_args[4]}
s3_bucket_name=${parsed_args[5]}

# Requirements
./parts/requirements.sh

# CoD2
export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key

./parts/cod2.sh $s3_bucket_name

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
