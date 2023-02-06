#!/bin/bash

DOMAIN=$(/opt/elasticbeanstalk/bin/get-config environment -k DOMAIN)
EFS_SSL_DIR=$(/opt/elasticbeanstalk/bin/get-config environment -k EFS_SSL_DIR)
EC2_SSL_BACKUP_DIR=$(/opt/elasticbeanstalk/bin/get-config environment -k EC2_SSL_BACKUP_DIR)

# Copy directory from $1 (source) to $2 (target) if target is empty
cp_dir_if_target_is_empty() {
  source=$1
  target=$2

  if [ -f "$source" ] || [ -f "$target" ]; then
    >&2 echo "ERROR: $source and $target must be a directory"
    exit 1
  fi
  # Create directory if not exist
  mkdir -p "$source"

  if [ -z "$(ls -A "$target")" ]; then
    echo "$target is empty, copying from $source"
    cp -R "$source/." "$target/"
  else
    echo "$target is not empty, do nothing"
  fi
}

# Sync certbot certificates
cp_dir_if_target_is_empty "${EFS_SSL_DIR}" "${EC2_SSL_DIR}"
cp_dir_if_target_is_empty "${EC2_SSL_DIR}" "${EC2_SSL_BACKUP_DIR}"
