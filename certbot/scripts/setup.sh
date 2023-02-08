#!/bin/bash

set -e

trap exit INT TERM

check_env() {
  if [[ -z "${!1}" ]]; then
    echo "$1 is not set"
    exit 1
  fi
}

check_env DOMAIN
check_env EC2_CERTBOT_DIR
check_env EC2_CERTBOT_BACKUP_DIR
check_env EFS_BASE_CERTBOT_DIR

# certbot_dir="/etc/letsencrypt/archives"
# dummy_dir="/etc/letsencrypt/live/$DOMAIN"

# if [ -d "$certbot_dir" ] && [ -n "$(ls -A "$certbot_dir")" ]; then
#   echo "Deleting dummy certificates for $DOMAIN"
#   rm -Rf "$dummy_dir"
#   echo "Done. Creating real certificates"
# fi

sleep 5s

certbot certonly --agree-tos --register-unsafely-without-email --domains "${DOMAIN}" --webroot --webroot-path /var/www/certbot