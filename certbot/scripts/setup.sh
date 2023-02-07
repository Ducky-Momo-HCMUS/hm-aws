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

certbot certonly \ 
        --webroot \
        --webroot-path /var/www/certbot/ \
        --agree-tos \
        --register-unsafely-without-email \
        --domains "${DOMAIN}"