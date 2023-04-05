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

# Installation

## Structure
./parts/structure.sh

## Libcod
sudo ./parts/required_packages.sh # elevated privilidges required for package instalation
./parts/libcod.sh

./parts/other.sh $mysql_password
