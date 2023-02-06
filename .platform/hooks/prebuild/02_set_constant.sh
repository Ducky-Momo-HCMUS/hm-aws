#!/bin/bash

export_env() {
    echo 'export $1' >> ~/.bashrc
}

export_env 'EFS_ID="fs-0fd3fd850a9d21c1a"'
export_env 'EFS_MOUNT_DIR="/efs"'
export_env 'EFS_DOMAIN_SSL_DIR="${EFS_MOUNT_DIR}/ssl/${DOMAIN}"'

export_env 'EC2_SSL_DIR="/etc/ssl/letsencrypt"'

cat ~/.bashrc
