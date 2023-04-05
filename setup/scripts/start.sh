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
s3_bucket_name=${parsed_args[5]}

export AWS_ACCESS_KEY_ID=${parsed_args[3]}
export AWS_SECRET_ACCESS_KEY=${parsed_args[4]}

# Installation

## Structure
./parts/structure.sh

## Libcod
# sudo ./parts/required_packages.sh # elevated privilidges required for package instalation
# ./parts/libcod.sh


# CoD2
./parts/cod2.sh $s3_bucket_name

./parts/other.sh $mysql_password

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
