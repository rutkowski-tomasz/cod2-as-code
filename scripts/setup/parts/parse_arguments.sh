#!/bin/bash

function parse_arguments() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --mysql_password=*)
        mysql_password="${1#*=}"
        ;;
      --user_name=*)
        user_name="${1#*=}"
        ;;
      --user_password=*)
        user_password="${1#*=}"
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
      *)
        echo "Unknown argument: $1"
        exit 1
      ;;
    esac
    shift
  done

  for arg_name in "mysql_password" "user_name" "user_password" "aws_access_key_id" "aws_secret_access_key" "s3_bucket_name"; do
    arg_value=$(eval echo \$$arg_name)
    if [ -z "$arg_value" ]; then
      echo "Error: Missing argument --${arg_name}"
      exit 1
    fi
  done

  echo "$mysql_password $user_name $user_password $aws_access_key_id $aws_secret_access_key $s3_bucket_name"
}
