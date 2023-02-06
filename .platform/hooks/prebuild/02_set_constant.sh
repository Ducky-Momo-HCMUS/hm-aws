#!/bin/bash

# Export all variable in this shell
set -o allexport

EFS_ID="fs-0fd3fd850a9d21c1a"
EFS_MOUNT_DIR="/efs"
EFS_DOMAIN_SSL_DIR="${EFS_MOUNT_DIR}/ssl/${DOMAIN}"

EC2_SSL_DIR="/etc/ssl/letsencrypt"

set +o allexport