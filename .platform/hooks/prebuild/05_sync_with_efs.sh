#!/bin/bash

DOMAIN=$(/opt/elasticbeanstalk/bin/get-config environment -k DOMAIN)
EFS_SSL_DIR=$(/opt/elasticbeanstalk/bin/get-config environment -k EFS_SSL_DIR)

cp_dir() {
  echo '$(ls -A "$1")'
  if [ -z '$(ls -A "$1")' ]; then
    echo "$1 is empty"
  else
    echo "$1 is not empty"
  fi
}

cp_dir "${EFS_SSL_DIR}"

# Sync certbot certificates
