#!/bin/bash

check_env() {
  if [[ -z "${!1}" ]]; then
    echo "$1 is not set"
    exit 1
  fi
}

check_env DOMAIN

certbot --nginx --reinstall --agree-tos --register-unsafely-without-email --domains "$DOMAIN"

if [ -z "$(dir -r "$EC2_CERTBOT_DIR" "$EC2_CERTBOT_BACKUP_DIR")" ]; then
  echo "No changes found in certbot configuration"
else
  echo "Changes found in certbot configuration, syncing"
  rsync -a --delete "$EC2_CERTBOT_DIR/" "$EC2_CERTBOT_BACKUP_DIR/"
  rsync -a --delete "$EC2_CERTBOT_BACKUP_DIR/" "$EFS_BASE_CERTBOT_DIR/"
  echo "Sync to EFS completed"
fi