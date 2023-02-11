#!/bin/bash

DOMAIN=$(/opt/elasticbeanstalk/bin/get-config environment -k DOMAIN)
EFS_BASE_CERTBOT_DIR=$(/opt/elasticbeanstalk/bin/get-config environment -k EFS_BASE_CERTBOT_DIR)
EC2_CERTBOT_BACKUP_DIR=$(/opt/elasticbeanstalk/bin/get-config environment -k EC2_CERTBOT_BACKUP_DIR)
EC2_CERTBOT_DIR=$(/opt/elasticbeanstalk/bin/get-config environment -k EC2_CERTBOT_DIR)

# Copy directory from $1 (source) to $2 (target) if target is empty
cp_dir_if_target_is_empty() {
  source=$1
  target=$2

  if [ -f "$source" ] || [ -f "$target" ]; then
    >&2 echo "ERROR: $source and $target must be a directory"
    exit 1
  fi
  # Create directories if not exist
  mkdir -p "$source"
  mkdir -p "$target"

  if [ -z "$(ls -A "$target")" ]; then
    echo "Directory $target is empty, copying from $source"
    cp -R "$source/." "$target/"
  else
    echo "Directory $target is not empty, do nothing"
  fi
  echo "Finished copying $source/ to $target/"
}

# See https://stackoverflow.com/q/18135451 for syntax like ${DOMAIN}
# Copy certificates from EFS to a backup directory
cp_dir_if_target_is_empty "$EFS_BASE_CERTBOT_DIR/$DOMAIN" "$EC2_CERTBOT_BACKUP_DIR"
# Now we should have the following if we use certbot:
# - ${EC2_CERTBOT_BACKUP_DIR}/live/...
# - ${EC2_CERTBOT_BACKUP_DIR}/archive/...
# - ... other certbot configurations

# Sync certificates to certbot directories
# https://eff-certbot.readthedocs.io/en/stable/using.html#where-are-my-certificates
cp_dir_if_target_is_empty "$EC2_CERTBOT_BACKUP_DIR" "$EC2_CERTBOT_DIR"