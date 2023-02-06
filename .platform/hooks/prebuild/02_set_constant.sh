#!/bin/bash

export EFS_ID="fs-0fd3fd850a9d21c1a"
export EFS_MOUNT_DIR="/efs"
export EFS_DOMAIN_SSL_DIR="${EFS_MOUNT_DIR}/ssl/${DOMAIN}"

export EC2_SSL_DIR="/etc/ssl/letsencrypt"